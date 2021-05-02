#!/bin/bash
# Write by afei

# judge install nginx
if rpm -qa |grep ^nginx-1 && rpm -qa |grep ^nginx-mod; then
	nginx -V
else
	yum -y install nginx
	nginx -V
fi

htpasswd -c /etc/nginx/prometheus.pass admin


sed -i "89c #" /etc/nginx/nginx.conf		#将nginx.conf配置文件中第89行替换成#
sed -i "s/80/8888/g" /etc/nginx/nginx.conf  #将nginx的80端口替换成8888

cat >> /etc/nginx/nginx.conf << "EOF"
  server {
      listen 8888;
      server_name server.com;   #域名，一般是公网

      location / {
	      auth_basic "prometheus";
          auth_basic_user_file "/etc/nginx/prometheus.pass";
          proxy_pass http://localhost:9090/;
      }
  }
}
EOF

systemctl start nginx
#systemctl restart nginx
systemctl status nginx