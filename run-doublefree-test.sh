#! /usr/bin/env bash
source ./setup_env.sh

for i in {1..1000}
do
    LD_PRELOAD=$SIGHANDLER_PATH LD_LIBRARY_PATH=$LIBFAB_PATH/lib:$MPI_PATH/lib:$LD_LIBRARY_PATH $MPI_PATH/bin/mpirun \
        -host phwtstl005:44,phwtstl006:44,phwtstl007:44,phwtstl008:44 \
        --output-filename $LOG_DIR/run \
        --mca btl_ofi_disable_sep 1 \
        --mca mtl_ofi_enable_sep 0 \
        --mca osc ^ucx \
        --mca pml ^ucx \
        --mca mtl ofi \
        --mca btl self,vader \
        --bind-to core \
        -x LD_LIBRARY_PATH="$LIBFAB_PATH/lib:$MPI_PATH/lib:$LD_LIBRARY_PATH" \
        -x FI_OPX_EXPECTED_RECEIVE_ENABLE=1 \
        -x FI_PROVIDER=opx \
        -x FI_OPX_RELIABILITY_SERVICE_PRE_ACK_RATE=64 \
        -x FI_OPX_RELIABILITY_SERVICE_USEC_MAX=500 \
        -x FI_OPX_DELIVERY_COMPLETION_THRESHOLD=2097153 \
        -x FI_OPX_UUID=4253 \
        -x LD_PRELOAD=$SIGHANDLER_PATH \
        -np 176 \
        $IMB_DIR/IMB-MPI1 -include Uniband,Biband -time 20 -iter 10000 -exclude reduce_scatter,reduce_scatter_block -npmin 176

        if [[ $? -ne 0 ]]
        then
            echo "MPI run failed"
	        exit 1
        fi
done 
