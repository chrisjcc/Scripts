#!/bin/sh

############################################
#                                          #
#   Write by: Christian Contreras-Campana  #
#   email: christian.contreras@desy.de     #
#   Date: 01.07.2015                       #
#                                          #
############################################

# Description: The following script merges the event-by-event information for synchronisation files based on whether if it's signal or background process

# Useage: ./install/bin/mergeEventByEventInfo.sh -p ttbarH -s Nominal -c emu (-o arg if -c is not called on)

# Parses command line option
function optparse {
    USAGE="Usage: ./install/bin/`basename $0` -p ttbarH -s Nominal -c emu -o ttH_JESUp [use -o option only if -c option is not used]"
    
    while getopts hvo:s:c:p:d OPT; do

        case "$OPT" in
            h)
		echo $USAGE
		exit 0
		;;
            v)
		echo "`basename $0` version 0.1"
		exit 0
		;;
            o)
		OUTPUT_FILE="$OPTARG"
		;;
	    d)
		echo "parse option takes in no arguments"
		DEBUG=true
		;;
	    s)
		SYSTEMATIC="$OPTARG"
		;;
	    c)
		CHANNEL="$OPTARG"
		;;
            p)
		PROCESS="$OPTARG"
		;;
            \?)
		# getopts issues an error message
		echo $USAGE >&2
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
        esac
    done
        
    # Remove the switches we parsed above.
    shift $((OPTIND-1))
}


# Function handles which event-by-event information files to merge
function function_name () {

    # Create csv directory in current working directory
    if [[ ! -d $PWD/csv ]];then
        cwd=`mkdir $PWD/csv; cd csv; echo "$PWD"`
    else
        cwd=`cd csv; echo "$PWD"`
    fi

    # Give local variables their corresponding global variable values
    process="$PROCESS"
    systematic="$SYSTEMATIC"
    channel="$CHANNEL"
    systematics=(Nominal JES_UP JES_DOWN)

    # File hearder containing column labeling
    fileHeader="run,lumi,event,is_e,is_mu,is_ee,is_emu,is_mumu,n_jets,n_btags,lep1_pt,lep1_iso,lep1_pdgId,lep2_pt,lep2_iso,lep2_pdgId,jet1_pt,jet1_eta,jet1_phi,jet1_jesSF,jet1_jesSF_up,jet1_jesSF_down,jet1_csv,jet2_pt,jet2_eta,jet2_phi,jet2_jesSF,jet2_jesSF_up,jet2_jesSF_down,jet2_csv,MET_pt,MET_phi,mll,ttHFCategory,n_interactions,puWeight,csvSF,csvSF_lf_up,csvSF_hf_down,csvSF_cErr1_down,triggerSF,lep_idSF,lep_isoSF,pdf_up,pdf_down,me_up,me_down,bdt_output,mem_output,dnn_ttH_output,dnn_ttbb_output"

    # If-statement selection is based on users input variables
    if [[ "${systematic}" != "*" && "${channel}" != "*" ]];then

        # Merge based on specified systematic and channel type
        dirPath="synchronisation/${systematic}/${channel}"
	inFile="${channel}_${channel}_${process}*.csv"
	outFile=$cwd/"${channel}_${channel}_${process}.csv"

        # Check if file(s) exist
        countNumOfFiles=$(ls $dirPath/$inFile 2> /dev/null | wc -l)

        if [[ "${countNumOfFiles}" == "0" ]];then
            echo "WARNING: The file(s) $dirPath/$inFile do not exist."
            exit
        fi

        # Remove original file headers and empty lines and order info based on event number
        cat $dirPath/$inFile | sed -r "s/${fileHeader}//g" | sed '/^$/d' > $outFile
        sed --in-place=.tmp "1s/^/${fileHeader}\n/" $outFile
        cat $outFile | awk 'NR<2{print $0;next}{print $0| "sort --field-separator=',' -k 3 -n"}' > $outFile.old
        mv $outFile.old $outFile

    elif [[ "${systematic}" != "*" && "${channel}" == "*" ]];then

        # Merge channel for based on systematic type
        dirPath="synchronisation/${systematic}/${channel}"
	inFile="*_${process}*.csv"
        outFile=$cwd/"${systematic}_${process}.csv"

        # Check if file(s) exist
        countNumOfFiles=$(ls $dirPath/$inFile 2> /dev/null | wc -l)

        if [[ "${countNumOfFiles}" == "0" ]];then
            echo "WARNING: The file(s) $dirPath/$inFile do not exist."
            exit
        fi

        # Remove original file headers and empty lines and order info based on event number
        cat $dirPath/$inFile | sed -r "s/${fileHeader}//g" | sed '/^$/d' > $outFile
        sed --in-place=.tmp "1s/^/${fileHeader}\n/" $outFile
        cat $outFile | awk 'NR<2{print $0;next}{print $0| "sort --field-separator=',' -k 3 -n"}' > $outFile.old

        if [[ ! -z $OUTPUT_FILE ]];then
            mv $outFile.old  $cwd/$OUTPUT_FILE.csv
            rm $outFile
        else
            mv $outFile.old $outFile
        fi

    elif [[ "$systematic" == "*" && "$channel" != "*" ]];then

        # Merge all systematic type based on channel type
        for systematic in "${systematics[@]}" ; do

            dirPath="synchronisation/${systematic}/${channel}"
	    inFile="${channel}_${channel}_${process}*.csv"
	    outFile=$cwd/"${channel}_${channel}_${process}.csv"

            # Check if file(s) exist
            countNumOfFiles=$(ls $dirPath/$inFile 2> /dev/null | wc -l)

            if [[ "${countNumOfFiles}" == "0" ]];then
                echo "WARNING: The file(s) $dirPath/$inFile do not exist."
                exit
            fi

            # Remove original file headers and empty lines and order info based on event number
            cat $dirPath/$inFile | sed -r "s/${fileHeader}//g" | sed '/^$/d' > $outFile
            sed --in-place=.tmp "1s/^/${fileHeader}\n/" $outFile
            cat $outFile | awk 'NR<2{print $0;next}{print $0| "sort --field-separator=',' -k 3 -n"}' > $outFile.old
            mv $outFile.old $outFile
        done

    elif [[ "${systematic}" == "*" && "${channel}" == "*" ]];then

        # Merge separately over all systematic and channel type
        for systematic in "${systematics[@]}" ; do

            dirPath="synchronisation/${systematic}/${channel}"
            inFile="*_${process}*.csv"
            outFile=$cwd/"${systematic}_${process}.csv"

            # Check if file(s) exist
            countNumOfFiles=$(ls $dirPath/$inFile 2> /dev/null | wc -l)

            if [[ "${countNumOfFiles}" == "0" ]];then
                echo "WARNING: The file(s) $dirPath/$inFile do not exist."
                exit
            fi

            # Remove original file headers and empty lines and order info based on event number
            cat $dirPath/$inFile | sed -r "s/${fileHeader}//g" | sed '/^$/d' > $outFile
            sed --in-place=.tmp "1s/^/${fileHeader}\n/" $outFile
            cat $outFile | awk 'NR<2{print $0;next}{print $0| "sort --field-separator=',' -k 3 -n"}' > $outFile.old
            mv $outFile.old $outFile
        done
    fi
}

# Parse command line options
optparse $@

# If variable is not definted then assign wildcard value
SYSTEMATIC=$([ "${SYSTEMATIC}" == '' ] && echo "*" || echo "${SYSTEMATIC}")
CHANNEL=$([ "${CHANNEL}" == '' ] && echo "*" || echo "${CHANNEL}")

# Execute function based on process type
if [[ -z "${PROCESS}" ]];then

    PROCESS="ttbarH"
    function_name $PROCESS $SYSTEMATIC $CHANNEL

    PROCESS="ttbar*ilepton"
    function_name $PROCESS $SYSTEMATIC $CHANNEL

else
    function_name $PROCESS $SYSTEMATIC $CHANNEL
fi

# Remove tmp files
rm $cwd/*.csv.tmp

# EOF

