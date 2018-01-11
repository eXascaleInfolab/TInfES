#!/bin/bash
# Converts resulting Kenza types from RDF to CNL using rdfconvert.py

if [ $# -ne 1 ] || [ "${1:0:1}" = "-" ]
then
	echo "Usage:  $0 <original_RDFs_dir>"
	exit 1
fi

INPDIR=kenza_pureres_types  # Input (processing directory). results of the Type Inference execution (Kenza, SDType)
SUPDIR=${1:-.}  # Supporting directory (original datasets: ../../input/kenzabased/ (biomedical, opengov)
APP=../../rdfconvert.py
OUTDIR=kenza_pureres_cnlTps

for FNAME in `find $INPDIR -maxdepth 1 -name "*.types"`
do
	NAME=${FNAME#$INPDIR/}
	#echo "Processing $NAME"
	NAME=${NAME%_[ms]t.types}
	find $SUPDIR -maxdepth 1 -name "$NAME.*" -exec $APP -t $FNAME -o $OUTDIR {} \;
done
