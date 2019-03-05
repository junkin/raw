#!/bin/bash
./install-conda-py37.sh && \
./setup-rapids-0.5.1-cuda10-gcc7-py37-env.sh && \
./add-xgboost-cudf-mnmg.sh && \
./add-dask-cuda-cudf.sh && \
./add-rapids-notebooks.sh
