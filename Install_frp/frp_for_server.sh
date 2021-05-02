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
cat >> /usr/local/frp_0.33.0_linux_amd64/frps.ini << "EOF"
#设置仪表盘
dashboard_port = 7500
dashboard_user = afei
dashboard_pwd = 123456

#设置web端口
vhost_http_port = 8088
vhost_https_port = 4433
EOF

./frpc -c frpc.ini &