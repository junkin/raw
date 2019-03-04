#!/bin/bash

source activate rapids 

pip install git+https://github.com/rapidsai/dask-xgboost@dask-cudf
pip install git+https://github.com/rapidsai/dask-cudf@master
pip install git+https://github.com/rapidsai/dask-cuda@master

