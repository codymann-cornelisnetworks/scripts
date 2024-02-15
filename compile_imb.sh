#! /usr/bin/env bash

source ./setup_env.sh

make -C $IMB_DIR clean
LD_LIBRARY_PATH=$LIBFAB_PATH/lib:$MPI_PATH/lib:$LD_LIBRARY_PATH CC=$MPI_PATH/bin/mpicc CXX=$MPI_PATH/bin/mpicxx make -C $IMB_DIR

if [[ $? -ne 0 ]]
then
    echo "Failed to build intel benchmarks"
    exit 1
fi