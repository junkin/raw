#!/bin/bash 
(
#set -e
ls -l

RAPIDS_DIR=${HOME}/rapids

echo '--------------------------------------------------------------------------------'
nvidia-smi
echo Uptime: $(uptime)
SYSTEM_GPUS="$(nvidia-smi -L | wc -l)"
export MAXGPUS=${MAXGPUS:-$SYSTEM_GPUS}
echo "Max GPUs = $MAXGPUS"
printenv

source activate rapids

#echo '---cudf built-in tests  ----------------------------------------------------'
#cd ${RAPIDS_DIR}/cudf/cpp/build
#make test

#echo '---cuML built-in tests  ----------------------------------------------------'
#cd ${RAPIDS_DIR}/cuml/cuML/build
#./ml_test

echo '---xgboost benchmark_linear  ----------------------------------------------------'
cd ${RAPIDS_DIR}/xgboost/tests/benchmark
ipython benchmark_linear.py
echo '---xgboost benchmark_tree  ----------------------------------------------------'
ipython benchmark_tree.py

cd ${RAPIDS_DIR}/notebooks/cuml

echo '---dbscan_demo  ----------------------------------------------------'
cat dbscan_demo.ipynb | grep -v "%%" > /tmp/dbscan_demo-test.ipynb
jupyter nbconvert --to script /tmp/dbscan_demo-test.ipynb --output /tmp/dbscan_demo-test
python /tmp/dbscan_demo-test.py
echo '---knn_demo  ----------------------------------------------------'
cat knn_demo.ipynb | grep -v "%%" > /tmp/knn_demo-test.ipynb
jupyter nbconvert --to script /tmp/knn_demo-test.ipynb --output /tmp/knn_demo-test
python /tmp/knn_demo-test.py
echo '---pca_demo  ----------------------------------------------------'
cat pca_demo.ipynb | grep -v "%%" > /tmp/pca_demo-test.ipynb
jupyter nbconvert --to script /tmp/pca_demo-test.ipynb --output /tmp/pca_demo-test
python /tmp/pca_demo-test.py
echo '---tsvd_demo  ----------------------------------------------------'
cat tsvd_demo.ipynb | grep -v "%%" > /tmp/tsvd_demo-test.ipynb
jupyter nbconvert --to script /tmp/tsvd_demo-test.ipynb --output /tmp/tsvd_demo-test
python /tmp/tsvd_demo-test.py
echo '---linear_regression_demo  ------------------------------------------'
cat linear_regression_demo.ipynb | grep -v "%%" > /tmp/linear_regression_demo-test.ipynb
jupyter nbconvert --to script /tmp/linear_regression_demo-test.ipynb --output /tmp/linear_regression_demo-test
python /tmp/linear_regression_demo-test.py
echo '---ridge regression demo   ------------------------------------------'
cat ridge.ipynb | grep -v "%%" > /tmp/ridge-test.ipynb
jupyter nbconvert --to script /tmp/ridge-test.ipynb --output /tmp/ridge-test
python /tmp/ridge-test.py

#echo '---E2E Mortgage  ----------------------------------------------------'
#cd ${SCRIPT_DIR}
#ipython E2E.py

)2>&1 | tee rapids.CUDA$CUDA_VERSION.$(date "+%Y.%m.%d-%H.%M.%S").log
