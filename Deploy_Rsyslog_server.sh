#!/bin/bash
# Author：afei
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

prepare_work(){
	systemctl stop firewalld && systemctl disable firewalld
	sed -i 's/enforcing/disabled/' /etc/selinux/config
	setenforce 0
	systemctl restart ntpd
}

parten_lvm(){
	fdisk -l
	read -p "请输入需要进行分区的新磁盘(如：sdb)：" X
	Y=$(ls /dev |grep $X)
	if [ "$Y" == "$X" ]; then
		fdisk /dev/$X
		partx -a /dev/$X
		echo "parten successfully！"
	else
		"请先添加硬盘，再进行分区操作！"
	fi

	read -p "请输入需要做LVM逻辑卷的分区(如：sdb1)：" A
	B=$(ls /dev |grep $A)
	if [ "$B" == "$A" ]; then
		pvcreate /dev/$A
		vgcreate -s 6M vg_$A /dev/$A
		lvcreate -L 9.9G -n lv_$A vg_$A
		mkfs.xfs /dev/vg_$A/lv_$A
		Lv_path=$(blkid |grep lv_sdb1 |awk -F: '{print $1}')
		mkdir /logs
		echo "$Lv_path /logs xfs defaults        0 0" >> /etc/fstab
		mount -a
		Chack1=$(echo $?)
		if [ $Chack1 == 0 ]; then
			df -hT |grep logs
		else
			echo "挂载或配置出错，请检查！"
		fi
	else
		echo "没有进行LVM操作！"
		mkfs.xfs /dev/$A
		mkdir /logs
		echo "/dev/$A /logs xfs defaults        0 0" >> /etc/fstab
		mount -a
		Chack2=$(echo $?)
		if [ $Chack2 == 0 ]; then
			df -hT |grep logs
		else
			echo "挂载或配置出错，请检查！"
		fi
	fi
}

rsyslog_confige(){
	sed -i 's/SYSLOGD_OPTIONS=""/SYSLOGD_OPTIONS="-m 0 -r"/' /etc/sysconfig/rsyslog
	cp /etc/rsyslog.conf /etc/rsyslog.conf.bak
	cat >> /etc/rsyslog.conf << "EOF"
# Provides UDP syslog reception
$ModLoad imudp
$UDPServerRun 514

# Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
$InputTCPMaxSessions 500

$template log1,"/logs/%HOSTNAME%/%$YEAR%-%$MONTH%-%$DAY%.log"
:fromhost-ip, isequal, "192.168.3.154" ?log1
$template log2,"/logs/%HOSTNAME%/%$YEAR%-%$MONTH%-%$DAY%.log"
:fromhost-ip, isequal, "192.168.3.155" ?log2
EOF
systemctl restart rsyslog && systemctl status rsyslog
}

read -p "是否开始部署Rsyslog日志服务器(y|n)：" O
if [ $O == 'y' -o $O == 'Y' ];then
	prepare_work
	parten_lvm
	rsyslog_confige
	Chack3=$(echo $?)
	if [ $Chack3 == 0 ]; then
		echo "Rsyslog日志服务器部署成功"
	else
		echo "Rsyslog日志服务器部署出错，请检查配置！"
	fi
else
	echo "正在退出部署..."
fi