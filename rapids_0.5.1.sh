#!/bin/sh
sudo apt install -y curl git gcc-7 g++-7 libboost-all-dev wget vim zlib1g-dev
sudo dpkg -i nccl-repo-ubuntu1804-2.4.2-ga-cuda10.0_1-1_amd64.deb
sudo apt-key add /var/nccl-repo-2.4.2-ga-cuda10.0/7fa2af80.pub
sudo apt update
sudo apt install libnccl2 libnccl-dev
sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-<version>/7fa2af80.pub
sudo apt-get update
sudo apt-get install cuda
