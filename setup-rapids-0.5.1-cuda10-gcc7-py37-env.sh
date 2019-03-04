#!/bin/bash

PYTHON_VERSION=3.7

if [ -f "rapids-0.5.1-cuda10-gcc7-py37.yaml" ]; then
    conda env create -f rapids-0.5.1-cuda10-gcc7-py37.yaml python=${PYTHON_VERSION}
fi

conda clean -a -y
