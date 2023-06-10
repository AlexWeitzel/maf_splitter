#!/bin/bash

#empy, just for test
say_a_word() {
    local print_me=$1
    echo $print_me
}

iterate_phyloP() {
    #inputs are flagg (.gp file), flago (output_dir of post_concat chr split), flagt (concat.maf location), flagp (prefix)
    local GP=$1
    local out_dir=$2
    local concat=$3 #location of concat file
    local prefix=$4 #prefix
    local subtree=$5 #subtree
    local feature_file=$6   #feature
    local mod_file=$7       #neutral_mod_file.mod


    #rest of code
    export chromList=`cat $GP | cut -f2 | sort -u | awk '{printf $1" " }'`
    export ref=mm10
    
    touch $out_dir$subtree/log_file.txt
    echo $subtree > $out_dir$subtree/log_file.txt

    for chr in $chromList; do
        touch $out_dir$chr.bed
        cat $feature_file | grep $chr$'\t' > $out_dir$subtree/$chr.bed;
    done
    mkdir $out_dir$subtree
    
    
    for chr in $chromList; do
        #echo "phyloP --method LRT --subtree $subtree --mode CONACC --features $out_dir$chr.bed $mod_file $out_dir$chr.maf > $out_dir./subtree_features_$chr";

        phyloP --method LRT --subtree $subtree --mode CONACC --features $out_dir$subtree/$chr.bed $mod_file $out_dir$chr.maf > $out_dir$subtree/subtree_features_$chr;
    done
}