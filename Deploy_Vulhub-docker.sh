#!/bin/bash
# Author：afei
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#判断并安装docker
if which docker; then
	docker --version
else
	echo "请先安装docker！"
	read -p "是否进行一键安装docker（y|n）：" X
	if [ $X == y -o $X == Y ]; then
		wget https://gitee.com/afei00123/shell_script/blob/master/Install_docker\(all\).sh
		sh Install_docker\(all\).sh
		docker --version
	else
		echo "安装docker失败！"
	fi
fi

if which python3; then
	python3 -V
else
	apt-get install python3 -y
	python3 -V
fi


if which pip3; then
	pip3 -V
else
	#apt install python3-pip
	curl -s https://bootstrap.pypa.io/get-pip.py | python3
	pip3 -V
fi

#部署Vulhub-docker环境
systemctl start docker && systemctl status docker
pip3 install docker-compose
docker-compose -v
#git clone https://github.com/vulhub/vulhub.git
git clone https://gitee.com/afei00123/vulhub.git
#进入某个漏洞环境进行构建
cd vulhub/flask/ssti
#docker-compose build
docker-compose up -d