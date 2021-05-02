#!/bin/bash

cd /opt/
if which wget; then
	wget https://get.helm.sh/helm-v2.14.1-linux-amd64.tar.gz
    tar -xzf helm-v2.14.1-linux-amd64.tar.gz
    cd linux-amd64/ && cp helm /usr/local/bin/ && ls /usr/local/bin/helm
else
    yum -y install wget
    wget https://get.helm.sh/helm-v2.14.1-linux-amd64.tar.gz
    tar -xzf helm-v2.14.1-linux-amd64.tar.gz
    cd linux-amd64/ && cp helm /usr/local/bin/ && ls /usr/local/bin/helm
    exit 1
fi