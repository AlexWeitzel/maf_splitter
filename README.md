# maf_splitter
# the purpose of this is to be able to run bash scripts inside docker containers
# basically, calling split_count_concat_maf.sh 
# e.g. ./scripts/outside_docker/split_count_concat_maf.sh -s subset -i ./scripts/inside_docker/ -o ./chr5_test_mafs/ -c ./output/peak_maf_size.txt -t ./output/concat.maf
# from the ./ directory, and passing in flags for subset, input, output_dir, count location, and concat location will start the 
# necessary docker images to tet this to work