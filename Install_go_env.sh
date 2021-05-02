#!/bin/bash
# Author：afei
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

wget -P /opt/ https://golang.google.cn/dl/go1.15.7.linux-amd64.tar.gz
tar -xzf /opt/go1.15.7.linux-amd64.tar.gz -C /usr/local/ && cd /usr/local/go/ &&  bin/go version
cat >> /etc/profile.d/go_profile.sh << "EOF"
export GOPATH=$HOME/go_workspace
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
EOF
source /etc/profile.d/go_profile.sh

go version