#!/bin/bash

# Evn perpare
systemctl stop firewalld && systemctl disable firewalld
sed -i 's/enforcing/disabled/' /etc/selinux/config
setenforce 0

# Install rely software
yum -y install wget sqlite-devel xz gcc automake autoconf python-devel vim sshpass lrzsz readline-devel zlib-devel openssl-devel epel-release git python3 python3-pip

# Upload and tar
cd /opt && tar -xzf jumpserver3.0.tar.gz
tar -xzf jumpserver2.0.tar.gz -C /opt
cd jumpserver/install/ && pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
sellp 1 && pip freeze

# Install configure database
yum -y install mariadb mariadb-server
systemctl start mariadb && systemctl enable mariadb && systemctl status mariadb
mysqladmin -uroot -p password 123456