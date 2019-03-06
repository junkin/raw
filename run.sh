#!/bin/bash

programname=$0

function usage {
    echo "usage: $programname [-cgd]"
    echo "  -c use CPU only, num sockets, num cores"
    echo "  -g use local GPUs, number of GPUs"
    echo "  -d use distributed dask"
    exit 1
}

export MKL_NUM_THREADS=$(( $(nproc) / $(nvidia-smi -L | wc -l) ))

# Set MAX values
MAX_GPUS=`nvidia-smi -L | wc -l`
MAX_CPU_SOCKETS=`lscpu | grep Socket | awk '{print($NF)}'`
MAX_CPU_CORES_PER_SOCKET=`lscpu | fgrep "Core(s) per socket" | awk '{print($NF)}'`

DFLAG=0
CFLAG=0
GFLAG=0

while getopts ":c:g:d" opt; do
  case ${opt} in
        c)
            n_cores=${OPTARG}
            if [ $n_cores -gt $MAX_CPU_CORES_PER_SOCKET ]; then
                n_cores=$MAX_CPU_CORES_PER_SOCKET
            fi
            CFLAG=1
            ;;
        g)
            n_gpus=${OPTARG}
            if [ $n_gpus -gt $MAX_GPUS ]; then
                n_gpus=$MAX_GPUS
            fi
            GFLAG=1
            ;;
        d)
            DFLAG=1
            ;;
        \?) echo "Usage: cmd [-c ncores] [-g ngpus] [-d]"
            ;;
        :)
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            ;;
  esac
done
shift $((OPTIND -1))

if [ $DFLAG == 1 ]; then
    if [ $GFLAG == 1 ] ; then
        python test-dask.py --use_distributed_dask --use_gpus_only
    elif [ $CFLAG == 1 ]; then
        python test-dask.py --use_distributed_dask --use_cpus_only
    fi
elif [ $GFLAG == 1 ]; then
    python test-dask.py --use_gpus_only --n_gpus=$n_gpus
elif [ $CFLAG == 1 ]; then
    python test-dask.py --use_cpus_only --n_cpu_sockets=${MAX_CPU_SOCKETS} --n_cpu_cores_per_socket=$n_cores
fi
