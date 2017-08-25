#!/bin/sh
# Creates directories corresponding to the ground-truth files to link resulting clustering there

GTSUF="_gt.cnl"
find -L -maxdepth 1 -type f -name "*$GTSUF" | while read GTNAME
do
	mkdir ${GTNAME%$GTSUF}
done 
