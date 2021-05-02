#!/bin/bash
# forbid root login
# Author：afei

read -p "是否禁用root账户远程登录(yes|no)：" A

if [ $A == yes ]; then
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