#!/bin/bash
# Author: afei

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
read -p "是否设置密码强度策略(yes|no)：" A
if [ $A == "yes" ]; then
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
		read -p "是否为空密码用户设置密码(yes|no)：" B
		if [ $B == "yes" ]; then
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