#! /bin/sh
#
# \brief Shuffle and reduce dataset to the specified ratio
# \author Artem Lutov <artem@exascale.info>
# \date 2017-08

RDR=4  # Reduction ratio
USAGE="Usage: $0 [-o <outdir>] <dataset> [<reduct_ratio>=${RDR}]  | -h
Shuffle the dataset and reduce it into the specified number of times outputting results to the file <dataset>_s(1/${RDR})
  -h,--help  - help
  -o,--outdir <outdir>  - output directory
  <dataset>  - input dataset file to be shuffled and reduced
  <reduct_ratio>  - reduction ratio, float >= 1, default: ${RDR}
"'  
  Batch execution:
  $ find input/ -name "*.rdf" -exec ./shufrds.sh -o input/acsds_s0.25/ {} \;
'
OUTDIR=""  # Output directory

while [ $1 ]
do
	case $1 in
	-h|--help)
		printf "$USAGE"
		exit 0
		;;
	-o|--outdir)
		shift
		OUTDIR=$1
		shift  # Shift the arguments
		;;
	*)
		if [ ! $DATASET ]
		then
			DATASET=$1  # Input dataset
		else
			RDR=$1
			# Verify $RDR value
			if [ $RDR -lt 1 ]
			then
				echo "Error: the ratio is out of range: $RDR < 1"
				exit 1
			fi
			# Verify that all parameters are parsed
			if [ -n "$2" ]
			then
				printf "Error: invalid too many parameters.\n\n$USAGE"
				exit 1
			fi
		fi
		shift
		;;
	esac
done

# Verify that the input dataset is specified
if [ ! $DATASET ]
then
	printf "Error: input dataset should be specified\n\n$USAGE"
	exit 1
fi

# Set default value if not specified to the base dir of the $DATASET
OUTDIR=${OUTDIR:="${DATASET%/*}"}
# Create the output directory if required
if [ ! -d $OUTDIR ]
then
	mkdir -p $OUTDIR
	if [ $? -ne 0 ]
	then
		echo "Error: output directory \"$OUTDIR\" creation failed: $?"
		exit $?
	fi
fi

OUTNAME="${DATASET##*/}"

# The number of lines (triples) in the input dataset
LINES=`wc -l "$DATASET" | sed -n 's|^\([0-9]*\).*|\1/$RDR\n|p' | bc`
# File suffix based on the reduction ratio
FSUF=_s0`echo "scale=2; 1/$RDR" | bc`

#echo Input arguments parsed, outputting with "$FSUF" suffix to the \""$OUTDIR"\"
FOUTP="$OUTDIR"/`echo "$OUTNAME" | sed "s/\([^.]*\)\(\..*\)*/\1${FSUF}\2/"`
shuf "$DATASET" | head -n $LINES > "$FOUTP"
echo "$DATASET is shuffled, reduced $RDR times and saved as $FOUTP"
