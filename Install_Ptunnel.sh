#!/bin/bash
# Write by afei
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Install rely
yum -y install byacc flex bison unzip lrzsz
wget -O /opt/libpcap-1.9.1.tar.gz http://www.tcpdump.org/release/libpcap-1.9.1.tar.gz
tar -xzf /opt/libpcap-1.9.1.tar.gz
cd libpcap-1.9.1
./configure && make -j 4 && make install -j 4

#Install Ptunnel
wget -O /opt/pingtunnel_linux64.zip https://github.com/esrrhs/pingtunnel/releases/download/2.4/pingtunnel_linux64.zip
unzip -d /root/ /opt/pingtunnel_linux64.zip