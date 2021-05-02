#!/bin/bash
# Set umask value
# Author：afei

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