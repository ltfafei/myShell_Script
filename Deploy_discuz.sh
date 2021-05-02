#!/bin/bash
# Author：afei
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Check_Services(){
	for service in nginx.service mysqld.service php-fpm.service
	do
		if [ -f /usr/lib/systemd/system/${service} ]; then
			if [ "${service}" == nginx.service ];then
				echo "=================================="
				echo "nginx检测完毕，nginx服务正常。"

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
			systemctl start mysqld && systemctl start nginx && systemctl start php-fpm
		fi
	done
}

Deploy_discuz(){
	cd /usr/share/nginx/html
	git clone https://gitee.com/ComsenzDiscuz/DiscuzX.git
	chmod -Rf 777 DiscuzX/upload/*
	# discuz数据库配置
	mysql -e "create database discuz charset=utf8;" -uroot -p123
	mysql -e "grant all on discuz.* to 'root'@'localhost' identified by 'cl';" -uroot -p123
	mysql -e "flush privileges;" -uroot -p123
	echo "============================================================"
	echo "数据库配置成功，可以开始安装discuz了。"
}

Install_discuz(){
	Check_Services
	Deploy_discuz
	if ! rpm -qa php-xml; then
		yum install -y php-xml --enablerepo remi-php70
		php -m |grep ^xml$
		systemctl restart php-fpm && systemctl restart nginx
	else
		php -m |grep ^xml$
	fi
	
	ip_add=$(ip addr | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -E -v "^127\.|^255\.|^0\." | head -n 1)
	echo "============================================================"
	echo "浏览器打开：http://${ip_add}/DiscuzX/upload，按照页面提示即可安装。"
	echo " "
}

echo "=================================="
echo "基于LNMP架构部署discuz"
echo "=================================="
echo " "
read -p "是否安装部署discuz(y|n)：" X
if [ $X == y -o $X == Y ]; then
	Install_discuz
else
	echo "=================================="
	echo "正在退出部署discuz..."
fi