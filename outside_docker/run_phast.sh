#!/bin/bash
#./scripts/outside_docker/split_count_concat_maf.sh -s subset -i ./scripts/inside_docker/ -o ./chr5_test_mafs/ -c ./output/peak_maf_size.txt -t ./output/concat.maf

main () {
    local command=$1


    #start_docker_image 
    local phast_container='my_phast'
    local script_source='./scripts/maf_splitter/inside_docker/phast_scripts.sh'
    source ./scripts/maf_splitter/outside_docker/docker_utils.sh #contains start_docker_image and d_wrap

    start_docker_image $phast_container "e3d0affb583b" 

    d_wrap_root $phast_container $script_source "$command"


    docker stop $phast_container
    docker rm $phast_container
}

main "$@"