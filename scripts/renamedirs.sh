#!/bin/sh
# Creates directories corresponding to the ground-truth files to link resulting clustering there

USAGE="Usage:  $0 [<inpsuf>] <outpsuf>
Rename directories matching groundtruth files with optinal additional <inputsuf> to the name with <outpsuf>
"

if [ $# -gt 2 ] || [ $# -eq 0 ]
then
	printf "Error: invalid arguments. $USAGE"
	exit 1
fi

if [$2]
then
	INPSUF="$1"
	OUTSUF="$2"
else
	INPSUF=""
	OUTSUF=$1
fi

echo "Renaming dirs with input suffix '$INPSUF' to the suffix '$OUTSUF'"
GTSUF="_gt.cnl"
find -L -maxdepth 1 -type f -name "*$GTSUF" | while read GTNAME
do
	DIR=${GTNAME%$GTSUF}
	mv "$DIR$INPSUF" "$DIR$OUTSUF"
done

