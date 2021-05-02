#!/bin/bash
# Write by afei

. /etc/os-release
case "$ID" in 
	rhel*|centos*)

	# install docker
	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	yum install docker-ce -y
	docker -v
	systemctl start docker
	;;

	ubuntu*|kali)
	# Install rely
	apt-get install -y apt-transport-https ca-certificates curl software-properties-common

	# Add repo
	echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" >> /etc/apt/sources.list.d/docker.list
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	# Install docker
	apt-get update
	apt install docker-ce -y
	docker -v
	systemctl start docker
	;;
	
	*)
	echo "Unknow System！"
esac

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