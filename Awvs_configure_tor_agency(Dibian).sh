#!/bin/bash
# Author：afei

# Install tor rely tools
apt-get update -y && apt-get upgrade -y && apt-get install tor privoxy python3 python3-pip -y
if which pip3;then
	pip3 -V
else
	cd /opt/ && wget https://bootstrap.pypa.io/get-pip.py
	python3 get-pip.py
	pip3 -V
fi

cd /hack_tools/ && git clone https://gitee.com/afei00123/Auto_Tor_IP_changer.git
cd Auto_Tor_IP_changer && ls && sleep 2
python3 install.py

if which docker; then
	echo "正在安装docker版awvs..."
	docker search awvs |grep docker-awvs && sleep 2
	docker pull secfa/docker-awvs
	docker images |grep awvs
	docker run -it -d -p 34430:3443 -v /opt/awvs secfa/docker-awvs
	docker ps |grep docker-awvs

	echo " "
	echo "-------------------------------------"
	echo "awvs13破解账号："
	echo "username：admin@admin.com"
	echo "password：Admin123"
	echo "-------------------------------------"
else
	echo "docker未安装，请先安装docker!!!"
fi

# Configure auto_tor
aut