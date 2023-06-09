#!/bin/bash
#./scripts/outside_docker/split_count_concat_maf.sh -s subset -i ./scripts/inside_docker/ -o ./chr5_test_mafs/ -c ./output/peak_maf_size.txt -t ./output/concat.maf
#
main () {
    while getopts "g:o:t:p:s:f:d:" opt; do
        case $opt in
            g) flagg=$OPTARG ;;     #gp for chrom_IDs
            o) flago=$OPTARG ;;     #output (re_split_maf) dir
            t) flagt=$OPTARG ;;     #input maf_concat location/filename
            p) flagp=$OPTARG ;;     #prefix
            s) flags=$OPTARG ;;     #subtree
            f) flagf=$OPTARG ;;     #total feature bed file
            d) flagd=$OPTARG ;;     #named tree modfile
            \?) echo "Invalid option: -$OPTARG" >&2 ;;
        esac
    done
    shift $((OPTIND-1))
    echo $flagg $flago $flagt $flagp $flags $flagf


    #start_docker_image 
    local kent_container='my_kent'
    local phast_container='my_phast'
    local maf_script_source='./scripts/maf_splitter/inside_docker/maf_scripts.sh'
    local phast_script_source='./scripts/maf_splitter/inside_docker/phast_scripts.sh'

    source ./scripts/maf_splitter/outside_docker/docker_utils.sh #contains start_docker_image and d_wrap

    start_docker_image $kent_container "50bc0194602d" 
    start_docker_image $phast_container "e3d0affb583b" 

    echo "break me"

   
    #d_wrap $kent_container $script_source "say_a_word $flags"
    #d_wrap $kent_container $script_source "split_up_mafs -s $flags -i $flagi -o $flago" #use -s subset_bed -s in_dir -o out_dir
    #d_wrap $kent_container $script_source "concatonate_maf_subsets $flagt $flago"
    #d_wrap $kent_container $script_source "maf_lengths $flago $flagc"
    #d_wrap $kent_container $script_source "both_maf_lengths $flago $flagc"
    
    d_wrap $kent_container $maf_script_source "chrom_split $flagg $flago $flagt $flagp"
    d_wrap_root $phast_container $phast_script_source "iterate_phyloP $flagg $flago $flagt $flagp $flags $flagf $flagd"


    docker stop $kent_container
    docker stop $phast_container
    docker rm $kent_container
    docker rm $phast_container
}

main "$@"