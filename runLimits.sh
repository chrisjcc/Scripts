#!/usr/bin/env bash


# Provide user with the given parameters
echo "Options provided: $@"

USAGE="Usage: `basename $0` [-hv] [-m arg] [-b arg] [-f arg] [-r arg] args"

# Parse command line options.
while getopts hvd:m:b:s: OPT; do
    case "$OPT" in
        h)
            echo $USAGE
            exit 0
            ;;
        v)
            echo "`basename $0` version 0.1"
            exit 0
            ;;
        d)
            DATACARDS=$OPTARG
            ;;
        m)
            MODE=$OPTARG
            ;;
        b)
            BLIND=$OPTARG
            ;;
        s)
            SYSTEMATIC=$OPTARG
            ;;
        \?)
            # getopts issues an error message
            echo $USAGE >&2
            exit 1
            ;;
    esac
done

if [ ${MODE} == "1D" ]
then
    CATEGORIES=( ttH_hbb_13TeV_dl_3j2t ttH_hbb_13TeV_dl_3j3t ttH_hbb_13TeV_dl_ge4j2t ttH_hbb_13TeV_dl_ge4j3t ttH_hbb_13TeV_dl_ge4jge4t ttH_hbb_13TeV_dl_merged )
    
elif [ ${MODE} == "2D" ]
then
    CATEGORIES=( ttH_hbb_13TeV_dl_3j2t ttH_hbb_13TeV_dl_3j3t ttH_hbb_13TeV_dl_ge4j2t ttH_hbb_13TeV_dl_ge4j3t_low ttH_hbb_13TeV_dl_ge4j3t_high ttH_hbb_13TeV_dl_ge4jge4t_low ttH_hbb_13TeV_dl_ge4jge4t_high ttH_hbb_13TeV_dl_merged ) 
fi

for VARIABLE in "${CATEGORIES[@]}"
do
    if [ ${BLIND} == "blind" ]
    then
	if [ "${SYSTEMATIC}" == 0 ]
	then
	    combine -M Asymptotic --run="blind" -m 125 -n _$VARIABLE -S $SYSTEMATIC $DATACARDS/$VARIABLE.txt >& $VARIABLE.lmt &
	else	    
	    combine -M Asymptotic --run="blind" -m 125 -n _$VARIABLE $DATACARDS/$VARIABLE.txt >& $VARIABLE.lmt &	    
	fi
    elif [ ${BLIND} == "unblind" ]
    then
	if [ "${SYSTEMATIC}" == 0 ]
        then
	    combine -M Asymptotic -m 125 -n _$VARIABLE -S $SYSTEMATIC $DATACARDS/$VARIABLE.txt >& $VARIABLE.lmt & 
	else
	    combine -M Asymptotic -m 125 -n _$VARIABLE $DATACARDS/$VARIABLE.txt >& $VARIABLE.lmt &
	fi
    fi
done





