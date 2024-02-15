#! /usr/bin/env bash
source ./setup_env.sh

# Define the libfabric installation directory
export LIBFABRIC_DEBUG_INSTALL=$BUILDS_DIR/libfabric-current.debug
# export LIBFABRIC_OPTIMIZED_INSTALL=$BUILDS_DIR/libfabric-current.optimized


mkdir -p $LIBFABRIC_DEBUG_INSTALL
rm -rf $LIBFABRIC_DEBUG_INSTALL/*

# mkdir -p $LIBFABRIC_OPTIMIZED_INSTALL
# rm -rf $LIBFABRIC_OPTIMIZED_INSTALL/*

make -C $LIBFAB_DIR distclean
cd $LIBFAB_DIR && $LIBFABDEVEL_DIR/build-scripts/build.sh -c gnu -t debug

if [[ $? -ne 0 ]]
then
    echo "Libfabric gnu-debug build failed."
    exit 1
fi

# make -C $LIBFAB_DIR distclean
# cd $LIBFAB_DIR && $LIBFABDEVEL_DIR/build-scripts/build.sh -c gnu -t optimized

# if [[ $? -ne 0 ]]
# then
#     echo "Libfabric gnu-optimized build failed."
#     exit 1
# fi