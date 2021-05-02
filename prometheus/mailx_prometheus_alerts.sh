#!/bin/bash
# Write by afei

# Install sendmail and test
yum -y install mailx sendmail dos2unix

cat >> /etc/mail.rc << "EOF"
set from=m184xxxxxxxx@163.com    			 #邮箱账号
set smtp=smtp.163.com						 #smtp邮箱类型
set smtp-auth-user=m184xxxxxxxx@163.com     #邮箱账号
set smtp-auth-password=XLxxxxxxxxxxxQB      #邮箱的授权码
set smtp-auth=login							 #login模式
EOF

echo "test 163 email, success." | mail -s "test" m18479685120@163.com