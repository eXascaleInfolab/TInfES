#!/bin/sh
# 
# \brief Evaluate output results of the type inference (clustering) in the custom directories
# \author Artem V L <artem@exascale.info>
# \date 2018-01

# [<outpfile>=eval.res]
USAGE="Usage:  $0 <evalapp> [OPTS...] <execnum> <gtdir> <inpdirs...>
  Execute specified evaluation app <execnum> times with the options OPTS on each <basename>_*.cnl \
file in each <inpdir> directory, evaluating against the <gtdir>/<basename>_gt*.cnl ground-truth.

  evalapp  - evaluating app (xmeasures, gecmi)
  OPTS..  - options of the evaluating app
  execnum  - the number of executions
  gtdir  - directory with the ground-truth .cnl files <basename>_gt*.cnl
  inpdirs  - directories with .cnl files to be evaluated against the corresponding <gtdir>/<basename>_gt*.cnl grouund-truth files

Examples:
  ./$0 ./xmeasures -fp 1 kenzabased_gt  statix/kenzabased
  ./$0 ./gecmi -n 5 kenzabased_gt  statix/kenzabased sdtype/kenzabased
"
# NOTE: this script should be started from the same folder as <evalapp>

#  outpfile  - results output file
EAPP=$1  # Evaluating app
EOPTS=""  # Options of the eval app
OUTPBASE="evals"
#RESCONF=${OUTPBASE}.rcp  # Resource consumption file
XNUM=1  # The number of executions
INPDIRS=""  # Input dirs

# Check for the input dir
if [ ! $3 ]
then
	printf "Error: The input directory is not specified.\n\n$USAGE"
	exit 1
fi

while [ $2 ]
do
	case $2 in
	-*)
		EOPTS="$EOPTS $2"
		shift
		;;
	*)
		XNUM=$2
		shift
		if [ ! $2 ] || [ -z $2 ] || [ ! -d $2 ]
		then
			printf "Error: The ground-truth directory (\"$2\") does not exist.\n$USAGE"
			exit 1
		fi
		GTDIR=$2
		shift
		while [ $2 ]
		do
			# Parse remained arguments
			if [ -z $2 ] || [ ! -d $2 ]
			then
				printf "Error: The input directory ($2) does not exist.\n$USAGE"
				exit 1
			fi
			INPDIRS="$INPDIRS $2"
			shift
		done
		break
		;;
	esac
done

EAPPNAME=${EAPP##*/}  # Remove base dir
OUTPF=${OUTPBASE}_${EAPPNAME}`echo $EOPTS | tr -d ' '`.txt  # Results output file

echo "Input parameters parsed, EAPP: $EAPP, EOPTS: $EOPTS, SXNUM: $XNUM, INPDIRS: $INPDIRS \nOutput file: $OUTPF"
# Add datetime mark to the output files if they already exist
#for FILE in "$OUTPF" "$RESCONF"
#do
	if [ -f "$OUTPF" ]
	then
		echo "-- `date -u +'%Y-%m-%d %R:%S'` -------" >> "$OUTPF"
	fi
#done

# Traverse over the ground-truth files and evaluate corresponding input clustering
for GTFILE in `find -L "$GTDIR" -maxdepth 1 -type f -name "*.cnl"`  # Consider linked files (-L)
do
	GTBNAME="`echo $GTFILE | sed 's/\(.*\)_gt.*\.cnl/\1/'`"
	GTBNAME=${GTBNAME##*/}  # Remove base dir
	# Skip missing files
	if [ -z GTBNAME ]
	then
		continue
	fi
	# Traverse the input dirs and evaluate required files
	for INPDIR in $INPDIRS
	do
		FOUND=0
		for INPFILE in `find -L "$INPDIR" -maxdepth 1 -type f -name "$GTBNAME*.cnl"`
		do
			FOUND=1
			INPFNAME=${INPFILE##*/}
			i=0
			while [ $i -lt $XNUM ]
			do
				# Show executing command, which is convenient for the logging
				echo "$EAPP" $EOPTS "$GTFILE" "$INPFILE" "| tail -n 1 |" sed "s/\(.*\)/$INPFNAME"'\\t \\1/'
				"$EAPP" $EOPTS "$GTFILE" "$INPFILE" | tail -n 1 | sed "s/\(.*\)/$INPFNAME\t \1/" >> "$OUTPF"
				i=$((i+1))
			done
			# Indent multiple executions
			if [ $XNUM -gt 1 ]
			then
				echo '' >> "$OUTPF"
			fi
		done
		# Show warnings for the missed files/dirs
		if [ $FOUND -eq 0 ]
		then
			echo "WARNING, there are no any *.cnl files found in the specified $INPDIR/"
		fi
	done	
done

#EAPPNAME=${EAPP##*/}
#./exectime -b -o="$RESCONF" -n="$EAPPNAME"_{} -s="/$OUTPBASE"
