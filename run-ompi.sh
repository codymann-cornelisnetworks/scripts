#! /usr/bin/env bash

source ./setup_env.sh

LD_PRELOAD=$SIGHANDLER_PATH LD_LIBRARY_PATH=$LIBFAB_PATH/lib:$MPI_PATH/lib64:$LD_LIBRARY_PATH $MPI_PATH/bin/mpirun \
    -n 2 \
    --host phkpstl067:1,phkpstl068:1 \
    --output-filename $LOG_DIR/run \
    --mca btl_ofi_disable_sep 1 \
    --mca mtl_ofi_enable_sep 0 \
    --mca osc ^ucx \
    --mca pml ^ucx \
    --mca mtl ofi \
    --mca btl self,vader \
    -x PATH=$MPI_PATH/bin:$PATH \
    -x LD_LIBRARY_PATH="$LIBFAB_PATH/lib:$MPI_PATH/lib64:$LD_LIBRARY_PATH" \
    -x FI_PROVIDER=opx \
    -x FI_OPX_UUID=${RANDOM} \
    -x FI_OPX_EXPECTED_RECEIVE_ENABLE=$FI_OPX_EXPECTED_RECEIVE_ENABLE \
    -x TIDFLOW_SET=$TIDFLOW_SET \
    -x FI_LOG_LEVEL=debug \
    $IMB_DIR/IMB-MPI1 Biband -iter 1 -npmin 2 -msglog 16:16 -zero_size 0  -warm_up off  -window_size 1 -iter_policy off -time 30000 
