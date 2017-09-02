#!/bin/sh
# Creates directories corresponding to the ground-truth files to link resulting clustering there

GTSUF="_gt.cnl"
USAGE="Usage:  $0
Crete directories corresponding to the ground-truth files (*${GTSUF})
"

if [ "${1%elp}" = "-h" ]
then
	printf "$USAGE"
	exit 0
fi

find -L -maxdepth 1 -type f -name "*$GTSUF" | while read GTNAME
do
	mkdir ${GTNAME%$GTSUF}
done 
