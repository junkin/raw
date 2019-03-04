#!/bin/bash

PYTHON_VERSION=3.7

CONDA_DIR=${HOME}/conda

if [ -d "${CONDA_DIR}" ]; then
    echo "Directory exists..."
    echo "Exiting..."
    exit
fi

rm -f /tmp/miniconda.sh
MINICONDA_URL=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
curl ${MINICONDA_URL} -o /tmp/miniconda.sh
sh /tmp/miniconda.sh -b -p ${CONDA_DIR}
${CONDA_DIR}/bin/conda update -n base conda -y
${CONDA_DIR}/bin/conda install -y python=${PYTHON_VERSION}
rm -f /tmp/miniconda.sh
