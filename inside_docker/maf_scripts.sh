#!/bin/bash

split_up_mafs() {
    #local flagn flagi flags
    while getopts "s:i:o:" opt; do
        case $opt in
            s) flags=$OPTARG ;;
            i) flagi=$OPTARG ;;
            o) flago=$OPTARG ;;
            \?) echo "Invalid option: -$OPTARG" >&2 ;;
        esac
    done
    shift $((OPTIND-1))


    #rest of code
    echo "Running: mafsInRegion $flags -outDir $flago /data/$flagi*.maf" #leaving the /data/ roots us at the base dir, set by docker
}

concatonate_maf_subsets() {
    #makes the file
    local file_name=$1
    local input_directory=$2
    touch /data/$file_name

    #this puts the header at the top
    echo "##maf version=1 scoring=blastz" > /data/$file_name
    #this just throws all of the mafs into one file, but it will be much smaller
    for file in $input_directory*.maf; do
        tail -n +2 "$file" >> /data/$file_name
    done

    
}
maf_lengths() {
    local folder=$1
    local output_file=$2
    touch /data/$output_file
    echo -e "peak_ID\tpeak_length" > $output_file
    for file in $folder*.maf; do
        name=`echo $file | awk -F'/' '{print $NF}' | cut -d'.' -f1`;
        var=`cat $file | sed 's/+/-/g' | grep mm10 | cut -d'-' -f1 | awk -F' ' '{print $NF}' | awk '{sum+=$1} END{print sum}'`
        echo -e "$name\t$var" >> $output_file

    done
}



both_maf_lengths() {
    local folder=$1
    local output_file=$2
    touch /data/$output_file
    echo -e "peak_ID\tmus_peak_length\tjac_peak_length" > $output_file
    for file in $folder*.maf; do
        #echo $file;
        name=`echo $file | awk -F'/' '{print $NF}' | cut -d'.' -f1`;
        #echo $name;
        mus_var=`cat $file | sed 's/+/-/g' | grep mm10 | cut -d'-' -f1 | awk -F' ' '{print $NF}' | awk '{sum+=$1} END{print sum}'`
        jac_var=`cat $file | sed 's/+/-/g' | grep 's HLjacJac2' | cut -d'-' -f1 | awk -F' ' '{print $NF}' | awk '{sum+=$1} END{print sum}'`

        echo -e "$name\t$mus_var\t$jac_var" >> $output_file

    done
}

say_a_word() {
    local print_me=$1
    echo $print_me
}