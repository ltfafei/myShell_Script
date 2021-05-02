#!/bin/bash
# Write by afei

# Upload install files

cd /opt/Nessus-8.9.1 && ls
dpkg -i Nessus-8.9.1-debian6_amd64.deb && sleep 2
systemctl start nessusd && systemctl enable nessusd && systemctl status nessusd
netstat -nltup |grep 8834

echo "浏览器访问：https://localhost:8834，进行初始化..."