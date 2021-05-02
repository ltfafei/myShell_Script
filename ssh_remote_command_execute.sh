#!/bin/bash
#original: wangfeng
#Write by afei

cat >> /etc/profile.d/getdate.sh << "EOF"
# 获取昨天日期函数
yesterday()
{
	date +'%Y-%m-%d' -d '-1 days'
}

# 获取今天日期函数
today()
{
	date +'%Y-%m-%d'
}

# ssh远程免交互执行函数
autologin_ssh ()
{
  expect -c "set timeout -1
	spawn -noecho ssh -o StrictHostKeyChecking=no $2 ${@:3};
	expect *assword:*;
	send -- $1\r;
	interact;";
}
EOF

sleep 3
source /etc/profile.d/getdate.sh