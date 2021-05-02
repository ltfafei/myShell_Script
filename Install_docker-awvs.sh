#!/bin/bash
# Author：afei

docker search awvs |grep docker-awvs && sleep 2
docker pull secfa/docker-awvs
docker images |grep awvs
docker run -it -d -p 34430:3443 -v /opt/awvs --restart=always secfa/docker-awvs
docker ps |grep docker-awvs

echo " "
echo "-------------------------------------"
echo "awvs13破解账号："
echo "username：admin@admin.com"
echo "password：Admin123"
echo "-------------------------------------"