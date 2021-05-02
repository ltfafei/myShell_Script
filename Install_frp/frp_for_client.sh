#!/bin/bash
# Install frp for server
# Write by afei
# 2020/07/30

# Preparation work
systemctl stop firewalld && systemctl disable firewalld
sed -i 's/enforcing/disabled/' /etc/selinux/config
setenforce 0

# Install frp
yum -y install wget lrzsz
wget -P /opt https://github.com/fatedier/frp/releases/download/v0.33.0/frp_0.33.0_linux_amd64.tar.gz
tar -xzf /opt/frp_0.33.0_linux_amd64.tar.gz -C /usr/local/
cd /usr/local/frp_0.33.0_linux_amd64/

# Conguration frp for server
server = xx.xx.xx.xx   #公网IP
perl -pi -e "s/^(server_addr = )(\S+)/server_addr = ${server}/" /usr/local/frp_0.33.0_linux_amd64/frpc.ini


cat >> /usr/local/frp_0.33.0_linux_amd64/frpc.ini << "EOF"
log_file = ./frpc.log    #设置日志记录

[web]
type = http
local_ip = 127.0.0.1
local_port = 80
http_user = afei
http_pwd = cl
custom_domains = www.afei.com

[dns]
type = udp
local_ip = 8.8.8.8
local_port = 53
remote_port = 6000

[sockets_for_docker]
type = tcp
remote_port = 6001
plugin = unix_domain_socket
plugin_unix_path = /var/run/docker.sock   #unix的socket路径
EOF

./frpc -c frpc.ini &