#! /bin/sh
#
# \brief Shuffle and reduce dataset to the specified ratio
# \author Artem Lutov <artem@exascale.info>
# \date 2017-08

RDR=4
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
	echo "Usage:  $0 <dataset> [<reduct_ratio=${RDR}]  | -h"\
		"\nShuffle the dataset and reduce it into the specified number of times"\
		" outputting results to the file <dataset>_s(1/${RDR})"\
		"\n"\
		"\nOptions:"\
		"\n-h [--help]  - help"\
		"\n<dataset>  - input dataset file to be shuffled and reduced"\
		"\n<reduct_ratio=${RDR}  - reduction ratio, float >= 1"
	exit $#
fi

if [ $# -ge 2 ]
then
	RDR=$2
	if [ $RDR -lt 1 ]
	then
		echo "The ratio is out of range: $RDR < 1"
		exit 1
	fi
fi

LINES=`wc -l $1 | sed -n 's|^\([0-9]*\).*|\1/2\n|p' | bc`
FSUF=_s0`echo "scale=2; 1/$RDR" | bc`

FOUTP=`echo $1 | sed "s/\([^.]*\)\(\..*\)*/\1${FSUF}\2/"`
shuf $1 | head -n $LINES > $FOUTP
echo "$1 is shuffled, reduced $RDR times and saved as $FOUTP"
