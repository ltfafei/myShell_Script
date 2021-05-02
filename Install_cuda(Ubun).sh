nvidia-smi && sleep 2
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
chmod +x cuda_10.2.89_440.33.01_linux.run
./cuda_10.2.89_440.33.01_linux.run
apt install nvidia-cuda-toolkit
nvcc -V && sleep 2

# Concuration env
echo "export PATH=/usr/local/cuda-10.2/bin:$PATH" | sudo tee -a /etc/profile
echo "export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:$LD_LIBRARY_PATH" | sudo tee -a /etc/profile
source /etc/profile
cd /usr/local/cuda-10.2/samples/1_Utilities/deviceQuery
make
./deviceQuery