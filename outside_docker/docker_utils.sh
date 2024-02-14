#!/bin/bash

#starts docker image, and can run commands sourced from another location within the docker image

start_docker_image() {
    #local flagn flagd
    echo "inside here"
    local name=$1
    local container_ID=$2
    echo $name $container_ID


    #rest of code
    docker run -dit --name $name -w /data/ -v $PWD:/data/ $container_ID

}

d_wrap() {
    container_ID=$1
    script_source=$2
    command=$3
    #echo $command
    docker exec -w /data/ $container_ID bash -c "
        source $script_source;
        $command"
}

d_wrap_root() {
    container_ID=$1
    script_source=$2
    command=$3
    #echo $command
    docker exec -w /data/ -u root $container_ID bash -c "
        source $script_source;
        $command"
}
