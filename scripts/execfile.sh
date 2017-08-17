#!/bin/sh
# 
# \brief Execute commands from the file evaluating resource consumption
# \author Artem V L <artem@exascale.info>
# \date 2017-08
# \version 1.1

# [<outpfile>=eval.res]
USAGE="Usage:  $0 <algexecs_file>
  Execute specified algorithm according to the specified exeuctions file evaluating the resource consumption.
  NOTE: 'exectime' should be located in the same dir as the current script.

  algexecs_file  - a file that  with specifies the algorithm executions in the format:
	# Comments and empty lines are allowed, I/O redirection is not supported in the execution command
	<taskname>  <execution_command>

Examples:
  ./execalg.sh statix.exs, where contents of the 'statix.exs':
    museum	./run.sh -f -g xdatasets/museum_s0.25.rdf -o results/statix/museum_s0.25.cnl datasets/museum.rdf
    ...
  ./execalg.sh sdtype.exs, where contents of the 'sdtype.exs':
    disambiguations_unredirected_en	java -jar es.jar datasets/museum.rdf sdtypex/instance_types_en.ttl sdtypex/disambiguations_unredirected_en.ttl
    ...
"

if [ $# -ne 1 ] || [ ! -f $1 ]
then
	printf "Error, invalid input parameters.\n\n$USAGE"
	exit 1
fi

#  outpfile  - results output file
EFILE=$1  # Executions specification file
OUTPBASE="evals"
#XNUM=1  # The number of executions

EAPPNAME=${EFILE##*/}  # Remove base dir
EAPPNAME=${EFILE%.*}  # Remove file extension
RESCNSF=${OUTPBASE}_${EAPPNAME}.rcp  # Resource consumption output file

if [ -f "$RESCNSF" ]
then
	echo "-- `date -u +'%Y-%m-%d %R:%S'` -------" >> "$OUTPF"
fi

# Note:
# -r prevents backslash escapes from being interpreted.
# || [[ -n $line ]] prevents the last line from being ignored if it doesn't end with a \n (since read returns a non-zero exit code when it encounters EOF).
while read -r EALG || [ -n "$EALG" ]
do
	# Skip empty lines and comments
	if [ -z "$EALG" ] || [ -z "${EALG%%#*}" ]
	then
		continue
	fi
	TASKNAME=`echo "$EALG" | sed 's/^\([^[:space:]]*\).*/\1/'`
	TASKCMD=`echo "$EALG" | sed 's/^[^[:space:]]*\s*\(.*\)/\1/'`
	echo "== Executing $TASKNAME ==="
	#echo "== Executing $TASKNAME:  $TASKCMD ==="
	# Note: $TASKCMD can't contain IO redirection and pipe commands
	./exectime -b -o="$RESCNSF" -n="$TASKNAME" -s="/$EAPPNAME" $TASKCMD
done < $EFILE

# Change log
# v1.1 - Task naming added
# v1.0 - Initial script
