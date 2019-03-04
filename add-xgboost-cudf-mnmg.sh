#!/bin/bash

CONDA_DIR=${HOME}/conda
RAPIDS_DIR=${HOME}/rapids

if [ ! -d "${RAPIDS_DIR}" ]; then
    mkdir -p ${RAPIDS_DIR}
else
    if [ -d "${RAPIDS_DIR}/xgboost" ]; then
        rm -rf ${RAPIDS_DIR}/xgboost
    fi
fi

# Set environment
CC_VERSION=$(  gcc --version | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/' | cut -d. -f1 )
CXX_VERSION=$( g++ --version | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/' | cut -d. -f1 )

if [ -f "/usr/bin/gcc-${CC_VERSION}" ]; then
    CC=/usr/bin/gcc-${CC_VERSION}
else
    CC=`which gcc`
fi

if [ -f "/usr/bin/g++-${CXX_VERSION}" ]; then
    CXX=/usr/bin/g++-${CXX_VERSION}
else
    CXX=`which g++`
fi

CUDAHOSTCXX=$CXX
CUDACXX=`which nvcc`

if [ ! -d "$CUDA_ROOT" ]; then
    CUDA_ROOT=/usr/local/cuda
fi

DEBIAN_FRONTEND=noninteractive
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CUDA_ROOT}/lib64
NUMBAPRO_NVVM=${CUDA_ROOT}/nvvm/lib64/libnvvm.so
NUMBAPRO_LIBDEVICE=${CUDA_ROOT}/nvvm/libdevice
PATH=$PATH:${CONDA_DIR}/bin
PARALLEL_LEVEL=4

source activate rapids && \
    pip uninstall xgboost

source activate rapids && \
    cd ${RAPIDS_DIR} && \
    git clone --recursive https://github.com/rapidsai/xgboost.git && cd xgboost && \
    git fetch && \
    git checkout cudf-mnmg-abi

source activate rapids && \
    mkdir build &&  cd build/ &&\
    cmake -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX \
          -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} \
          -DCMAKE_CXX11_ABI=ON \
          -DUSE_CUDA=ON -DUSE_NCCL=ON -DCMAKE_BUILD_TYPE=release \
	  -DCUDA_CUDART_LIBRARY=/usr/local/cuda/lib64/libcudart.so \
	  -DCUDA_INCLUDE_DIRS=/usr/local/cuda/include \
          -DGDF_INCLUDE_DIR=$CONDA_PREFIX/include .. && \
    make -j4 && \
    cd ${RAPIDS_DIR}/xgboost/python-package && \
    python setup.py bdist_wheel && \
    pip install ${RAPIDS_DIR}/xgboost/python-package/dist/xgboost-0.80-py3-none-any.whl

