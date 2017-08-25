#!/bin/sh

USAGE="$0 <results_dir>
Link *.cnl files from the specified directory to the current one respecting the folders
Example:  ./linkfiles.sh ../results/statix/biomedical
"

if [ $# -ne 1 ]
then
	printf "$USAGE"
	exit 1
fi

RDIR=$1
find -maxdepth 1 -type d | while read SDIR
do
	# Skip ".", process only "./" ...
	if [ ${#SDIR} -eq 1 ]
	then
		continue
	fi
	# Retain only the dir names without the leading ./
	NAME=${SDIR##*/}
	#echo $NAME
	find -L "$RDIR" -maxdepth 1 -type f -name "$NAME*.cnl" -exec ln -s "../{}" "$NAME/" \;
done
