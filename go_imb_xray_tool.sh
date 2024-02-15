#! /usr/bin/env bash

source ./setup_env.sh

if [[ ! -d $IMB_SAMPLE_DIR ]]
then
    mkdir -p $IMB_SAMPLE_DIR
else
    rm -rf $IMB_SAMPLE_DIR
fi

LD_LIBRARY_PATH=$LIBFAB_PATH/lib:$MPI_PATH/lib:$MPI_PATH/lib64:$LD_LIBRARY_PATH $MPI_PATH/bin/mpirun \
   -output-filename $LOG_DIR/run \
   -host phkpstl067:2,phkpstl068:2 \
   --mca btl_ofi_disable_sep 1 \
   --mca mtl_ofi_enable_sep 0 \
   --mca osc ^ucx \
   --mca pml ^ucx \
   --mca mtl ofi \
   --mca btl self,vader \
   --bind-to core \
   -x LD_LIBRARY_PATH="$LIBFAB_PATH/lib:$MPI_PATH/lib:$MPI_PATH/lib64:$LD_LIBRARY_PATH" \
   -x FI_OPX_EXPECTED_RECEIVE_ENABLE=0 \
   -x FI_PROVIDER=opx \
   -x FI_OPX_RELIABILITY_SERVICE_PRE_ACK_RATE=64 \
   -x FI_OPX_RELIABILITY_SERVICE_USEC_MAX=500 \
   -x FI_OPX_DELIVERY_COMPLETION_THRESHOLD=2097153 \
   -x FI_OPX_UUID=4253 \
   -x IMB_SAMPLE_DIR=/home/cmann/imbsamples \
   -np 4 \
    $IMB_DIR/IMB-MPI1 -iter 512 -iter_policy off -warm_up on -zero_size off -msglog 10:18 Scatter,Allgather