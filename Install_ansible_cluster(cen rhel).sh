#!/bin/bash
# Write by afei

# Define hosts var
m1=10.10.10.6
n1=10.10.10.7
n2=10.10.10.5

# Install ansible
if ! rpm -qa |grep ansible; then
	yum -y install epel-release wget 
	cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	yum -y install ansible && ansible --version
else
	ansible --version
fi

# Configure ssh no-pass
ssh-keygen -t rsa
ssh-copy-id $m1
ssh-copy-id $n1
ssh-copy-id $n2

# Edit hosts file
cat >> /etc/ansible/hosts << EOF
[nodes]
$m1
$n1
$n2
EOF

# Test ansible
ansible -i /etc/ansible/hosts nodes -m ping