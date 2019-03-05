export XDG_RUNTIME_DIR=""
export PATH="$HOME/conda/bin:$PATH"
export CUDA_ROOT=/usr/local/cuda  ## NOTE: change this env variable to match your environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_ROOT/lib64
export NUMBAPRO_NVVM=$CUDA_ROOT/nvvm/lib64/libnvvm.so
export NUMBAPRO_LIBDEVICE=$CUDA_ROOT/nvvm/libdevice
