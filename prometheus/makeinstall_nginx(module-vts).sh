#!/bin/bash
#Write by afei

# remove yum install nginx
if rpm -qa |grep nginx-1.* && rpm -qa|grep nginx-mod; then
	yum -y remove nginx && yum -y autoremove nginx
else
	echo ""
	echo "nginx not install!"
	echo ""
fi

# Wget nginx-module-vts
wget -P /opt/ https://github.com/vozlt/nginx-module-vts/archive/v0.1.18.tar.gz
tar -xzf /opt/nginx-module-vts-0.1.18.tar.gz -C /usr/local/src

# make install nginx
yum -y install gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel
wget -P /opt/ http://nginx.org/download/nginx-1.16.0.tar.gz
tar -xzf /opt/nginx-1.16.0.tar.gz -C /usr/local/src
cd /usr/local/src/nginx-1.16.0
./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_stub_status_module
if [ $? == 0 ]; then
	make -j4 && make install
	if [ $? == 0 ]; then
		ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/
		nginx -V && sleep 3
	else
		echo "make nginx error !"
	fi
else
	echo "configure nginx error !"
fi

# Add nginx-module-vts
./configure --add-module=/usr/local/src/nginx-module-vts-0.1.18 --prefix=/usr/local/nginx
make -j4	#don't make install
nginx -V && sleep 2

# Start nginx
nginx && netstat -nltup |grep nginx
# Stop nginx
#nginx -s stop
