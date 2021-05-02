#!/bin/bash
# Author：afei
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Centos7换源函数
Change_yum_repo(){
	url1=http://mirrors.aliyun.com/repo/Centos-7.repo
	url2=http://mirrors.163.com/.help/CentOS7-Base-163.repo
	# 获取url响应状态码
	code_st1=$(curl --connect-time 6 -I -s -o /dev/null -w %{http_code} ${url1})
	code_st2=$(curl --connect-time 6 -I -s -o /dev/null -w %{http_code} ${url2})
	mv -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
	if [ $code_st1 -eq 200 ];then
		wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	elif [ $code_st1 != 200 -a $code_st2 -eq 200 ];then
		wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo
	else
		mv -f /etc/yum.repos.d/CentOS-Base.repo.bak /etc/yum.repos.d/CentOS-Base.repo
		echo "无法下载yum源，换源失败"
	fi
	yum makecache
}

# 安装MySQL_5.7函数
Install_mysql(){
	wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
	rpm -ivh mysql57-community-release-el7-11.noarch.rpm
	yum -y install mysql mysql-devel mysql-server
	if echo $? == 0 ;then
		echo "mysql5.7安装成功"
		mysql -V
	else
		echo "mysql5.7安装失败！"
		exit
	fi
}

# 安装PHP_7.0函数
Install_PHP(){
	yum update -y && yum -y install epel-release yum-utils
	#rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
	yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
	yum install -y php php-common php-fpm php-opcache php-gd php-mysqlnd php-mbstring php-pecl-redis php-pecl-memcached php-devel --enablerepo remi-php70
	if echo $? == 0 ;then
		echo "php安装成功"
		php -v
	else
		echo "php安装失败！"
		exit
	fi
}

# 安装Nginx函数
Install_nginx(){
	wget http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
	rpm -ivh nginx-release-centos-7-0.el7.ngx.noarch.rpm
	yum -y install epel-release && yum -y install nginx
	systemctl start nginx && systemctl enable nginx
	if echo $? == 0; then
		echo "nginx安装成功"
		nginx -v
	else
		echo "nginx安装失败！"
		exit
	fi
}

Deploy_main(){
	# 确认操作系统
	Centos_ver=$(cat /etc/redhat-release | grep ' 7.' | grep -i centos)
	if [ "$Centos_ver" ]; then
		Change_yum_repo
	else
		echo "system is not Centos7，change yumrepo fail！"
	fi
	
	# 检测并卸载mariadb并安装mysql5.7
	if [ "rpm -qa mariadb" ];then
		yum remove mariadb* -y && yum autoremove -y
		if [ "! rpm -qa mariadb" ];then
			echo "mariadb卸载完成"
		fi
	else
		echo "未检测到mariadb！"
	fi
	echo ""
	echo "开始安装MySQL5.7"
	Install_mysql

	# 检测并卸载其他版本php并安装PHP7.0
	if ! rpm -qa php;then
		php_ver=$(php -v |grep 'PHP'|head -n 1 |awk '{print $2}')
		if [ `expr $php_ver \<= 7.0.0` -eq 1 ];then
			yum remove php* -y && yum autoremove -y
		echo "低版本php卸载完成，开始安装PHP7.0"
			Install_PHP
		else
			echo "已存在PHP大于7.0版本，不需要重新安装"
		fi
	else
		Install_PHP
	fi

	# 安装nginx
	Install_nginx

	#创建php测试页面并测试
	echo "<?php phpinfo(); ?>" >> /usr/share/nginx/html/index.php
	mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
	cat >> /etc/nginx/conf.d/default.conf << "EOF"
server {
    listen       80;
    server_name  localhost;
    location / {
        root   /usr/share/nginx/html;
        index  index.php index.html index.htm;
    }
    error_page   404              /404.html;
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
    location ~ \.php$ {
        root           html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /usr/share/nginx/html/$fastcgi_script_name;
        include        fastcgi_params;
    }
}
EOF
	systemctl restart nginx
	systemctl start php-fpm && systemctl enable php-fpm
	ip_add=$(ip addr | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -E -v "^127\.|^255\.|^0\." | head -n 1)
	url_stat=$(curl --connect-time 6 -I -s -o /dev/null -w %{http_code} http://${ip_add}/index.php)
	if [ $url_stat -eq 200 ]; then
		echo "==========================="
		echo "PHP info页面测试成功"
		echo "==========================="
	else
		echo "==========================="
		echo "PHP info测试失败！"
		echo "==========================="
	fi
	
	# 初始化Mysql数据库
	systemctl start mysqld && systemctl enable mysqld
	mysql_secure_installation
}

read -p "是否开始部署LNMP架构(y|n)：" X
if [ $X == 'y' -o $X == 'Y' ];then
	Deploy_main
else
	echo "正在退出部署LAMP架构脚本..."
fi