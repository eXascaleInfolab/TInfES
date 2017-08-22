#!/bin/sh
# 
# \brief Evaluate output results of the type inference (clustering)
# \author Artem V L <artem@exascale.info>
# \date 2017-08

# [<outpfile>=eval.res]
USAGE="Usage:  $0 <evalapp> [OPTS...] <execnum> <inpdirs...>
  Execute specified evaluation app <execnum> times with the options OPTS on each .cnl \
file in each <inpdir> directory, evaluating against the <inpdir>_gt.cnl ground-truth.

  evalapp  - evaluating app (xmeasures, gecmi)
  OPTS..  - options of the evaluating app
  execnum  - the number of executions
  inpdirs  - directories with .cnl files to be evaluated against the corresponding <inpdir>_gt.cnl grouund-truth files

Examples:
  ./eval.sh ./xmeasures -fp 1 museum 
  ./eval.sh ./gecmi -n 5 museum country
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

echo "Input parameters parsed, EAPP: $EAPP, XNUM: $XNUM, INPDIRS: $INPDIRS, EOPTS: $EOPTS; output file: $OUTPF"
# Add datetime mark to the output files if they already exist
#for FILE in "$OUTPF" "$RESCONF"
#do
	if [ -f "$OUTPF" ]
	then
		echo "-- `date -u +'%Y-%m-%d %R:%S'` -------" >> "$OUTPF"
	fi
#done

# Evaluate files int from the input directory
for INPDIR in $INPDIRS
do
	FOUND=0
	for INPFILE in `find -L "$INPDIR" -maxdepth 1 -type f -name "*.cnl"`
	do
		FOUND=1
		# Check existence of the GT file
		if [ ! -r "$INPDIR"_gt.cnl ]
		then
			echo "WARNING, the ground-truth file \""$INPDIR"_gt.cnl\" does not exist, $INPDIR/ is omitted"
			continue
		fi
		INPFNAME=${INPFILE##*/}
		i=0
		while [ $i -lt $XNUM ]
		do
			"$EAPP" $EOPTS "$INPFILE" "$INPDIR"_gt.cnl | tail -n 1 | sed "s/\(.*\)/$INPFNAME\t \1/" >> "$OUTPF"
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

#EAPPNAME=${EAPP##*/}
#./exectime -b -o="$RESCONF" -n="$EAPPNAME"_{} -s="/$OUTPBASE"
