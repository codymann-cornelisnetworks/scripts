#! /usr/bin/env bash

source run-config.sh

echo "Cleaning log directory $LOG_DIR"
if [[ -d $LOG_DIR ]];
then
	rm $LOG_DIR/*
else
	mkdir -p $LOG_DIR
fi

echo "Compiling srtest."
source $MPI_PATH/env/vars.sh
$MPI_PATH/bin/mpicc srtest.c -o srtest -g 

echo "Running srtest."
    LD_LIBRARY_PATH=$LIBFABRIC_PATH/lib:$LD_LIBRARY_PATH FI_OPX_UUID=${RANDOM} \
    FI_LOG_LEVEL=debug \
    I_MPI_PIN_PROCESSOR_LIST=0,1,32,33,2,3,34,35 \
    $MPI_PATH/bin/mpiexec \
    -hosts de-gen001,de-gen002\
    -outfile-pattern=$LOG_DIR/output.log-%r-%h \
    -errfile-pattern=$LOG_DIR/output.err-%r-%h \
    -n 8 \
    -ppn 4 \
    /home/cmann/test-scripts/srtest

echo "Processing hfi selection distribution."
./process_hfi_distri.py
