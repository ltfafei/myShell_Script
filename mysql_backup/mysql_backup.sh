#!/bin/bash
# Write by afei
# crontab: 
# * * 1 * * mysqldump -uroot -p<passwd> wordpress > /opt/mysql_backup/wordpress.sql
echo "Mysql Backup Script"

read -p "Please input database user: " user
read -p "Please input database password: " pwd
read -p "Please input database for backup: " db
date="$(date +%Y-%m-%d)"
mysql -u"$user" -p"$pwd" -e "show databases;"
mysqldump -u"$user" -p"$pwd" "$db" > /opt/mysql_backup/"$db"_"$date".sql

if [ $? -eq 0 ];then
	echo "mysql数据库备份完成。"
else
	echo "mysql备份失败，请确认配置是否有误！"
fi 