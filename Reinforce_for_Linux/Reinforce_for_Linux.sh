#!/bin/bash
# Author: afei

echo "1.设置系统密码策略"
echo " "
echo "如不需要进行操作，直接回车跳过即可。"
read -p "请设置用户密码不过期最大天数：" A
read -p "请设置修改密码时间间隔：" B
read -p "请设置密码的最小长度：" C
read -p "请设置密码失效前多久提示：" D

sed -i "/^PASS_MAX_DAYS/c\PASS_MAX_DAYS   $A" /etc/login.defs
sed -i "/^PASS_MIN_DAYS/c\PASS_MIN_DAYS   $B" /etc/login.defs
sed -i "/^PASS_MIN_LEN/c\PASS_MIN_LEN    $C" /etc/login.defs
sed -i "/^PASS_WARN_AGE/c\PASS_WARN_AGE   $D" /etc/login.defs
echo " "
echo "密码策略设置成功！"
echo " "
sed -n '18,28p' /etc/login.defs
echo " "

echo "2.禁用或删除无用账号"
echo " "
echo "从以下可登录账号进行选择操作！"
echo -------------------------------
cat /etc/passwd |grep -v "nologin"
echo " "
echo "如不需要进行操作，直接回车跳过即可。"
read -p "请输入需要删除的无用账号：" E
read -p "请输入需要锁定的账号(锁定之后用户不能修改密码哦！)：" F
read -p "请输入需要解锁的账号：" G
read -p "请输入需要查看的账号：" H

userdel -r $E 2>/dev/null
passwd -l $F 2>/dev/null
passwd -u $G 2>/dev/null
passwd -S $H 2>/dev/null

echo "3.管理系统用户"
echo " "
echo " "
echo "----------------------------------"
echo "系统中具有登录权限的用户有："
awk -F ':' '($7=="/bin/bash" || $7=="/bin/sh"){print $1,$7}' /etc/passwd
echo " "

echo "----------------------------------"
echo "系统中UID=0的用户有："
awk -F ':' '($3==0){print $1,"UID为："$3}' /etc/passwd   
echo " "

echo "----------------------------------"
echo '''
	请设置密码强度策略。
	强度策略规则：
		1.至少8位字符；
		2.至少包含一个大小写字母和数字；
		3.修改密码的话，新密码和旧密码必须有3个字符不相同；
		4.输入密码至少确认3次；
		5.密码不能过于简单。
'''
read -p "是否设置密码强度策略(yes|no)：" I
if [ $I == "yes" ]; then
	sed -i '10i password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=  difok=3 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1' /etc/pam.d/system-auth
	echo "密码强度策略设置成功"
else
	echo "密码强度策略没有设置成功！！!"
fi
echo " "

Cou=`awk -F ':' '($2==""){print $1}' /etc/shadow|wc -l`
echo "----------------------------------"
echo "系统中空密码的用户有"$Cou"个。"

# awk中NR表示行，打印第几行
if [ $Cou -eq 0 ]; then
	echo "恭喜系统中无空密码用户。"
else
		echo "必须为用户设置密码，否则该用户将会删除！"
		read -p "是否为空密码用户设置密码(yes|no)：" J
		if [ $J == "yes" ]; then
			i=1
			while [ $Cou -gt 0 ]
			do
				Nul=`awk -F ':' '($2==""){print $1}' /etc/shadow |awk 'NR=='$i'{print}'`
				echo "系统中空密码的用户：" $Nul
				echo " "
				echo "请设置密码(注意密码策略)："
				passwd $Nul
				let Cou--
			done
			echo "所有账户密码设置完成，系统中不存在空密码用户。"
		else
			j=1
			while [ $Cou -gt 0 ]
			do
				Del=`awk -F ':' '($2==""){print $1}' /etc/shadow |awk 'NR=='$j'{print}'`
				userdel -r $Del
				let Cou--
			done
			echo "系统中空密码用户已删除"
		fi
fi

echo "4.设置正确的umask值"
echo " "
UVALUE=$(umask)

if [ $UVALUE -eq 0022 ]; then
	echo "umask值设置正确。"
else
	echo "umask值设置不正确，正在重新设置umask值。UID大于199 umask值设置为002，UID小于199 umask值设置为022"
	
	sed -i '60c umask 002' /etc/profile && sed -i '60s/^/    /' /etc/profile
	sed -i '62c umask 022' /etc/profile && sed -i '62s/^/    /' /etc/profile
fi

echo " "
echo "umask值设置完成"
sed -n '60p' /etc/profile
sed -n '62p' /etc/profile

echo " "
echo "umask值设置正在生效..."
sleep 2 && source /etc/profile
UVALUE2=$(umask)
echo "当前系统的umask为：" $UVALUE2

echo "5.禁用root账号ssh远程登录"
echo " "
read -p "是否禁用root账户远程登录(yes|no)：" K

if [ $K == yes ]; then
	perl -pi -e "s/^(PermitRootLogin yes)/PermitRootLogin no/" /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config |grep PermitRoot
	echo " "
	echo "正在重启服务..."
	systemctl restart sshd
	echo "已禁止root账号ssh登录"
else
	echo ""
	cat /etc/ssh/sshd_config |grep PermitRoot
	echo "禁用root账户远程登录未设置成功！"
fi

echo "6.预防Syn flood攻击"
echo " "
echo "Syn_flood攻击防御 "
echo "------------------------"
echo " "
echo "(1).系统内核层面设置："
echo " "
read -p "请设置最大软硬件和打开文件连接数(1-65535)：" L
read -p "请设置Syn队列长度：" M
read -p "请设置Syn重连次数：" N
read -p "请设置Synack重连次数：" O
read -p "请设置是否开启Syn cookie(yes|no)：" P

echo " "
echo "(2).系统防火墙设置："
echo " "
read -p "请设置Syn并发数每秒多少次(输入数字即可)：" Q
read -p "请设置Syn、Fin、Ack、Rst转发数每秒多少次：" R
read -p "请设置icmp转发请求数每秒多少次：" S

ulimit -HSn $L
echo " "
ulimit -HSn
sysctl -w net.ipv4.tcp_max_syn_backlog=$M
echo "net.ipv4.tcp_max_syn_backlog="$M >> /etc/sysctl.conf
sysctl -w net.ipv4.tcp_syn_retries=$N
echo "net.ipv4.tcp_syn_retries="$N >> /etc/sysctl.conf
sysctl -w net.ipv4.tcp_synack_retries=$O
echo "net.ipv4.tcp_synack_retries="$O >> /etc/sysctl.conf

if [ $P == 'yes' ]; then
	sysctl -w net.ipv4.tcp_syncookies=1
   echo "net.ipv4.tcp_syncookies=1"  >> /etc/sysctl.conf
	if [ $P == 'no' ]; then
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
iptables -A INPUT -p tcp --syn -m limit --limit $Q/s -j ACCEPT
iptables -A FORWARD -p tcp --tcp-flags SYN,FIN,ACK,RST RST -m limit --limit $R/s -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit $S/s -j ACCEPT
iptables -L
echo "系统防火墙设置完成。"