#!/bin/bash
# Write by afei

# Install rely
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common python3-software-properties gpg gpgconf

# Install docker
# 方法1:
#curl -fsSL https://get.docker.com -o /opt/get-docker.sh
#sh /opt/get-docker.sh
#service docker start && service docker status

# Speed docker
mkdir /etc/docker
cat >> /etc/docker/daemon.json << "EOF"
{
    "registry-mirrors": ["https://gzvb5ox3.mirror.aliyuncs.com"]
}
EOF

service docker start && ps -e |grep "docker"

# Test docker
docker pull hello-world && docker images