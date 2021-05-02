#!/bin/bash
# Install ohpc-slurm use ansible
# Write by afei

a1=192.168.99.211
a1_host=ansible
n1=192.168.99.212
n1_host=node01
n2=192.168.99.213
n2_host=node02

# 1.Prepar work
systemctl stop firewalld && systemctl disable firewalld
sed -i 's/enforcing/disabled/' /etc/selinux/config
setenforce 0
cat >> /etc/hosts << EOF
$a1 $a1_host
$n1 $n1_host
$n2 $n2_host
EOF
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum -y install ntp
echo "server time.windows.com perfer" >> /etc/ntp.conf
systemctl restart ntpd && systemctl enable ntpd

# 2.Install ohpc-repo and slurm config
yum -y install epel-release
yum -y install http://build.openhpc.community/OpenHPC:/1.3/CentOS_7/x86_64/ohpc-release-1.3-1.el7.x86_64.rpm
yum -y install ohpc-base ohpc-warewulf ohpc-slurm-server nfs
lscpu && sleep 1
perl -pi -e "s/ClusterName=(\S+)/ClusterName=openHPC/" /etc/slurm/slurm.conf
perl -pi -e "s/ControlMachine=(\S+)/ControlMachine=$a1_host/" /etc/slurm/slurm.conf
perl -pi -e "s/^(#ControlAddr=)/ControlAddr=$a1/" /etc/slurm/slurm.conf
perl -pi -e "s/^NodeName=(\S+)/NodeName=node[01-02]/" /etc/slurm/slurm.conf
perl -pi -e "s/Sockets=2/Sockets=1/" /etc/slurm/slurm.conf
perl -pi -e "s/CoresPerSocket=8/CoresPerSocket=1/" /etc/slurm/slurm.conf
perl -pi -e "s/ThreadsPerCore=2/ThreadsPerCore=1/" /etc/slurm/slurm.conf
perl -pi -e "s/^PartitionName=(\S+)/PartitionName=nodes/" /etc/slurm/slurm.conf
perl -pi -e "s/Nodes=(\S+)/Nodes=$n_sl[01-02]/" /etc/slurm/slurm.conf
perl -pi -e "s/MaxTime=24:00:00/MaxTime=INFINITE/" /etc/slurm/slurm.conf
head -13 /etc/slurm/slurm.conf
sleep 2
tail /etc/slurm/slurm.conf
sleep 3
systemctl start slurmctld && systemctl enable slurmctld
systemctl start munge && systemctl enable munge

# 3.Speed pip
mkdir /root/.pip && touch /root/.pip/pip.conf
cat >> /root/.pip/pip.conf << EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple
[install]
use-mirrors = true
mirrors = http://mirrors.aliyun.com/pypi/simple
trusted-host = mirrors.aliyun.com
EOF

# 4.Install python-3.7.3 for ansible-2.9.9
yum -y remove python3 python3-pip && yum -y autoremove
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel gcc gcc-c++
wget -P /opt/ https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz && tar -xvf /opt/Python-3.7.3.tgz /opt/
mkdir /usr/local/python3 && cd /opt/Python-3.7.3
./configure --prefix=/usr/local/python3 && make -j4 && make install -j4
echo $? && sleep 1
ln -s /usr/local/python3/bin/python3.7 /usr/bin/python3
ln -s /usr/local/python3/bin/pip3.7 /usr/bin/pip
python3 -V && pip -V && sleep 2
pip install ansible==2.9.9
pip show ansible && pip freeze ansible && sleep 2
ln -s /usr/local/python3/bin/ansible /usr/bin/ansible
ln -s /usr/local/python3/bin/ansible-config /usr/bin/ansible-config
ln -s /usr/local/python3/bin/ansible-connection /usr/bin/ansible-connection
ln -s /usr/local/python3/bin/ansible-doc /usr/bin/ansible-doc
ln -s /usr/local/python3/bin/ansible-galaxy /usr/bin/ansible-galaxy
ln -s /usr/local/python3/bin/ansible-inventory /usr/bin/ansible-inventory
ln -s /usr/local/python3/bin/ansible-playbook /usr/bin/ansible-playbook
ln -s /usr/local/python3/bin/ansible-pull /usr/bin/ansible-pull
ansible --version

# 4.Add ansible hosts_file and ping
mkdir /etc/ansible
wget -P /etc/ansible https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg
cat >> /etc/ansible/hosts << EOF
$a1 ansible_ssh_pass='lanever'
$n1 ansible_ssh_pass='lanever'
$n2 ansible_ssh_pass='lanever'
[nodes]
$n1
$n2
[nodes:vars]
ansible_ssh_pass='lanever'
EOF
yum -y install sshpass
ansible -i /etc/ansible/hosts all -m ping