#!/bin/sh

echo "You used input: $@"

# Set environmental variables to corresponding script path
source $(dirname `readlink -f $0`)/parallelTools.sh

SCRIPT=$(readlink -f $0)
SCRIPTPATH=$(dirname "$SCRIPT")

# Get file from commandline argument
INPUT=$1

COUNT=0
NUMOFITERS=2

GEO=""
RUN=""

# Setup regex expressions
regex_run="run ([0-9]*)"
regex_geo="geo (geo_.*.dat)"

# Loop through input file to set a map with key-value pair (ie. run, geo.dat file)
while read LINE
do
    if [[ $LINE =~ "#" ]];then
        continue
    fi

    if [[ $LINE =~ $regex_run ]]; then RUN=${BASH_REMATCH[1]}; fi
    if [[ $LINE =~ $regex_geo ]]; then GEO=${BASH_REMATCH[1]}; fi

    if [[ $RUN != "" ]] && [[ $GEO != "" ]];then
	GEOFILE[$RUN]=$GEO
    fi
done < $INPUT


for RUN in "${!GEOFILE[@]}";do
    $TA -g ${GEOFILE[$RUN]} $RUN &
done

sleep 6

for iter in `seq 1 $NUMOFITERS`;do

    JOBID=($(qstat -u $USER | grep tele | awk -v jobCounter=$((COUNT+1)) '{array[i++]=$1}END{for(j=0+jobCounter;j<length(array);++j) printf"%s ",array[j]}'))
    INDEX=0
    #echo ${iter}, ${#JOBID[@]}

    for RUN in "${!GEOFILE[@]}";do 
    	#qsub -l distro=sld6 -hold_jid ${JOBID[$((INDEX++))]} -@ ${SCRIPTPATH}/qsubParams.txt ${SCRIPTPATH}/tele -g ${GEOFILE[$i]} $i &
	qsub -l distro=sld6 -hold_jid ${JOBID[$((INDEX+1))]} -@ ${SCRIPTPATH}/qsubParams.txt ${SCRIPTPATH}/tele -g ${GEOFILE[$RUN]} $RUN & 
	#echo "JobID: "${JOBID[${INDEX}]},$INDEX,$COUNT
    done 
    sleep 6
done

wait

if [ "$isNAF" = 1 ]; then
    echo "Please check your jobs with qstat -u $USER | grep tele"
else
    echo "Processing all nominal samples finished!"
fi
