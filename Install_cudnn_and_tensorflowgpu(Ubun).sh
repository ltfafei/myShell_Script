# 1.Install cudnn
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/7.6.5.32/Production/10.1_20191031/cudnn-10.1-linux-x64-v7.6.5.32.tgz

tar -xzf cudnn-10.1-linux-x64-v7.6.5.32.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
sleep 2

# 2.Pip install spec version tensorflowgpu
# Change pip repo
mkdir /root/.pip && touch /root/.pip/pip.conf
cat >> /root/.pip/pip.conf << EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple
[install]
use-mirrors = true
mirrors = http://mirrors.aliyun.com/pypi/simple
trusted-host = mirrors.aliyun.com
EOF

pip -V
pip install tensorflow-gpu==1.4.0
#pip3 install tensorflow-gpu==1.4.0