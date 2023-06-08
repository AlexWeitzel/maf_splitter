#!/bin/bash
# ./scripts/outside_docker/test.sh -s subset -i ./scripts/inside_docker/ -o ./chr5_test_mafs/ -c ./count_data_rimmatime.txt -t ./look_rimma.maf

main () {
    while getopts "s:i:o:c:t:" opt; do
        case $opt in
            s) flags=$OPTARG ;;     #subset maf file
            i) flagi=$OPTARG ;;     #input maf
            o) flago=$OPTARG ;;     #output (split maf) dir
            c) flagc=$OPTARG ;;     #maf_count file location/name.txt
            t) flagt=$OPTARG ;;     #maf_concat location
            \?) echo "Invalid option: -$OPTARG" >&2 ;;
        esac
    done
    shift $((OPTIND-1))
    echo $flags $flagi $flago $flagc $flagt


    local in_dir='./chr5_test_mafs/'

    #start_docker_image 
    local kent_container='my_kent'
    local script_source='./scripts/inside_docker/maf_scripts.sh'
    source ./scripts/outside_docker/docker_utils.sh #contains start_docker_image and d_wrap

    start_docker_image $kent_container "50bc0194602d" 
    echo "break me"

   
    d_wrap $kent_container $script_source "say_a_word $flags"
    d_wrap $kent_container $script_source "split_up_mafs -s $flags -i $flagi -o $flago" #use -s subset_bed -s in_dir -o out_dir
    d_wrap $kent_container $script_source "concatonate_maf_subsets $flagt $flago"
    #d_wrap $kent_container $script_source "maf_lengths $flago $flagc"
    d_wrap $kent_container $script_source "both_maf_lengths $flago $flagc"


    docker stop $kent_container
    docker rm $kent_container
}

main "$@"