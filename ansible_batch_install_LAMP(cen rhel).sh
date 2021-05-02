#!/bin/bash
# Write by afei

# Define hosts var
m1=10.10.10.6
n1=10.10.10.7
n2=10.10.10.5

# Install ansible
if ! rpm -qa |grep ansible; then
	yum -y install epel-release wget 
	cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	yum -y install ansible && ansible --version
else
	ansible --version
fi

# Configure ssh no-pass
ssh-keygen -t rsa
ssh-copy-id $m1
ssh-copy-id $n1
ssh-copy-id $n2

# Edit hosts file
cat >> /etc/ansible/hosts << EOF
[nodes]
$n1
$n2
EOF

# Test ansible
ansible -i /etc/ansible/hosts nodes -m ping

# Master install LAMP
yum -y install http http-devel mariadb-server mariadb mysql-php php php-devel curl
cat >> /var/www/html/index.php << EOF
<?php
        phpinfo();
?>
EOF
systemctl start httpd mariadb && systemctl enable httpd mariadb && systemctl status httpd mariadb
curl -I http://$m1
sleep 3

# Edit ansible playbooks
mkdir -pv /etc/ansible/lamp/roles/{prepare,httpd,mysql,php}/{tasks,files,templates,vars,meta,default,handlers}
cp /etc/httpd/conf/httpd.conf /etc/ansible/lamp/roles/httpd/files/
cp /etc/my.cnf /etc/ansible/lamp/roles/mysql/files/
cat >> /etc/ansible/lamp/roles/prepare/tasks/main.yml << EOF
- name: rely software install
  shell: yum -y install curl wget

- name: backup yumrepo
  shell: cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak

- name: provide yumrepo files
  shell: wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo  

- name: clean the yum repo
  shell: yum clean all 

- name: clean the iptables
  shell: iptables -F
EOF

cp /var/www/html/index.php /etc/ansible/lamp/roles/httpd/files/
cat >> /etc/ansible/lamp/roles/httpd/tasks/main.yml << EOF
- name: install apache
  yum: name=httpd state=present

- name: provide test pages
  copy: src=index.php dest=/var/www/html/

- name: delete apache config
  shell: rm -rf /etc/httpd/conf/httpd.conf

- name: provide configuration file
  copy: src=httpd.conf dest=/etc/httpd/conf/httpd.conf
  
  notify: restart httpd
EOF

cat >> /etc/ansible/lamp/roles/httpd/handlers/main.yml << EOF
- name: restart httpd
  service: name=httpd enabled=yes state=restarted
EOF

cat >> /etc/ansible/lamp/roles/mysql/tasks/main.yml << EOF
- name: install the mysql
  yum: name=mariadb-server state=present

- name: provide configuration file
  copy: src=my.cnf dest=/etc/my.cnf

- name: start mysql
  service: name=mariadb enabled=yes state=started
EOF

cat >> /etc/ansible/lamp/roles/php/tasks/main.yml << EOF
- name: install the php
  yum: name=php state=present

- name: install the php-mysql
  yum: name=php-mysql state=present
EOF

cat >> /etc/ansible/lamp/roles/site.yml << EOF
- name: LAMP build
  remote_user: root
  hosts: nodes
  roles:
   - prepare
   - mysql
   - php
   - httpd
EOF

ansible-playbook -i /etc/ansible/hosts /etc/ansible/lamp/roles/site.yml
curl -I http://$n1
curl -I http://$n2