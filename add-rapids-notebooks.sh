#!/bin/bash


RAPIDS_DIR=${HOME}/rapids

if [ ! -d "${RAPIDS_DIR}" ]; then
    mkdir -p ${RAPIDS_DIR}
else
    if [ -d "${RAPIDS_DIR}/notebooks" ]; then
        rm -rf ${RAPIDS_DIR}/notebooks
    fi
fi


NOTEBOOK_REPO=https://github.com/rapidsai/notebooks.git
source activate rapids && \
    cd ${RAPIDS_DIR} && \
    git clone --recursive ${NOTEBOOK_REPO} && cd notebooks && \
    git fetch && \
    git checkout fea-ext-cuml-benchmark-notebook