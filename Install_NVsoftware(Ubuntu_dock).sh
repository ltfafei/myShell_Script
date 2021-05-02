#!/bin/bash
# Write by afei

if ! which docker; then

	# Install docker
	apt-get install -y apt-transport-https ca-certificates curl software-properties-common
	echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" >> /etc/apt/sources.list.d/docker.list
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	apt-get update
	apt install docker-ce -y
	docker -v && systemctl start docker
fi
docker -v && systemctl start docker
# Speed docker
mkdir /etc/docker
cat >> /etc/docker/daemon.json << EOF
{
    "registry-mirrors": ["https://gzvb5ox3.mirror.aliyuncs.com"]
}
EOF
systemctl reload docker && systemctl restart docker && systemctl enable docker
docker info |tail

# Test docker
docker pull hello-world && docker images

docker pull nvidia/cuda
docker pull nvidia/cuda-ppc64le
docker pull nvidia/driver


# pull tensorflow and run
#docker pull tensorflow/tensorflow                     # latest stable release
#docker pull tensorflow/tensorflow:devel-gpu           # nightly dev release w/ GPU support
docker pull tensorflow/tensorflow:latest-gpu-jupyter  # latest release w/ GPU support and Jupyter

docker run --name tensorflow -it -p 8888:8888 -v /opt/tensorflow:/opt/data tensorflow/tensorflow:nightly-py3-jupyter
#docker run --name tensorflow -it -p 8888:8888 -v /opt/tensorflow:/opt/data tensorflow/tensorflow
#docker run -it -p 8888:8888 tensorflow/tensorflow:nightly-py3-jupyter