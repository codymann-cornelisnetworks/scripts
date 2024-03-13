#! /usr/bin/env bash

# source ./setup_env.sh
source setup_env_b2b.sh

LD_LIBRARY_PATH=$LIBFAB_PATH/lib:$MPI_PATH/lib:$LD_LIBRARY_PATH $MPI_PATH/bin/mpicc $MPI_PROGRAMS/$1.c -o $MPI_PROGRAMS/$1 
