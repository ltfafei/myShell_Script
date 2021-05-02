#!/bin/bash
# Write by afei

# 1.install CUDA 9.0

wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux.run

# Check install env
lspci |grep -i NVIDIA
rpm -qa |grep gcc
rpm -qa |grep kernel-devel
sleep 3

chmod +x cuda_9.0.176_384.81_linux.run
./cuda_9.0.176_384.81_linux.run