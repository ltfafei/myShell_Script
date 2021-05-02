#!/bin/bash
# Defense syn flood
# Author：afei

echo "Syn_flood攻击防御 "
echo "------------------------"
echo " "
echo "1.系统内核层面设置："
echo " "
read -p "请设置最大软硬件和打开文件连接数(1-65535)：" A
read -p "请设置Syn队列长度：" B
read -p "请设置Syn重连次数：" C
read -p "请设置Synack重连次数：" D
read -p "请设置是否开启Syn cookie(yes|no)：" E

echo " "
echo "2.系统防火墙设置："
echo " "
read -p "请设置Syn并发数每秒多少次(输入数字即可)：" F
read -p "请设置Syn、Fin、Ack、Rst转发数每秒多少次：" G
read -p "请设置icmp转发请求数每秒多少次：" H

ulimit -HSn $A
echo " "
ulimit -HSn
sysctl -w net.ipv4.tcp_max_syn_backlog=$B
echo "net.ipv4.tcp_max_syn_backlog="$B >> /etc/sysctl.conf
sysctl -w net.ipv4.tcp_syn_retries=$C
echo "net.ipv4.tcp_syn_retries="$C >> /etc/sysctl.conf
sysctl -w net.ipv4.tcp_synack_retries=$D
echo "net.ipv4.tcp_synack_retries="$D >> /etc/sysctl.conf

if [ $E == 'yes' ]; then
	sysctl -w net.ipv4.tcp_syncookies=1
   echo "net.ipv4.tcp_syncookies=1"  >> /etc/sysctl.conf
	if [ $E == 'no' ]; then
		sysctl -w net.ipv4.tcp_syncookies=0
           echo "net.ipv4.tcp_syncookies=0" >> /etc/sysctl.conf
	else
		echo "输入有误！"
	fi
fi
sysctl -p && sysctl -a| grep _syn
echo "系统内核层面设置完成。"
echo " "

iptables -F
iptables -A INPUT -p tcp --syn -m limit --limit $F/s -j ACCEPT
iptables -A FORWARD -p tcp --tcp-flags SYN,FIN,ACK,RST RST -m limit --limit $G/s -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit $H/s -j ACCEPT
iptables -L
echo "系统防火墙设置完成。"