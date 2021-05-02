#!/bin/bash
# Author：afei
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Check_Services(){
	for service in httpd.service mysqld.service php-fpm.service
	do
		if [ -f /usr/lib/systemd/system/${service} ]; then
			if [ "${service}" == httpd.service ];then
				echo "=================================="
				echo "apache检测完毕，httpd服务正常。"

			elif [ "${service}" == mysqld.service ];then
				echo "=================================="
				echo "mysql数据库检测完毕，mysqld服务正常。"
				echo "=================================="
			elif php -v || ${service} == php-fpm.service; then
				echo "=================================="
				echo "PHP环境检测完毕，PHP服务正常。"
				echo "=================================="
			else
				echo"LAMP环境异常，请检查httpd、mysql、php服务！"
				exit
			fi
			systemctl start mysqld && systemctl start httpd && systemctl start php-fpm
		fi
	done
}

Install_wordpress(){
	yum -y install lrzsz epel-release unzip
	wget -P /opt/ https://wordpress.org/latest.zip
	unzip -d /var/www/html latest.zip
	# 配置数据库
	mysql -e "create database wordpress;" -uroot -p123
	mysql -e "grant all on wordpress.* to 'afei'@'localhost' identified by 'cl';" -uroot -p123
	mysql -e "flush privileges;" -uroot -p123
	mysql -e "show databases;;" -uroot -p123 && sleep 2
	cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
	sed -i 's/database_name_here/wordpress/' /var/www/html/wordpress/wp-config.php
	sed -i 's/username_here/afei/' /var/www/html/wordpress/wp-config.php
	sed -i 's/password_here/cl/' /var/www/html/wordpress/wp-config.php
	echo "============================================================"
	echo "数据库配置成功，可以开始安装wordpress了。"
}

Deploy_wordpress(){
	Check_Services
	Install_wordpress
	ip_add=$(ip addr | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -E -v "^127\.|^255\.|^0\." | head -n 1)
	echo "============================================================"
	echo "浏览器打开：http://${ip_add}/wordpress，按照页面提示即可安装。"
}

echo "=================================="
echo "基于LAMP架构部署wordpress"
echo "=================================="
echo " "
read -p "是否安装部署wordpress(y|n)：" X
if [ $X == y -o $X == Y ]; then
	Install_wordpress
else
	echo "=================================="
	echo "正在退出部署wordpress..."
fi