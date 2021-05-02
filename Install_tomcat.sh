#!/bin/bash
# Write by afei

# Judeg install openjdk and install jdk-1.8
if rpm -qa |grep java; then
	rm -rf $(which java)
else
    # 现在需要登录oracle官网才能下载
	wget -P /opt https://www.oracle.com/webapps/redirect/signon?nexturl=https://download.oracle.com/otn/java/jdk/8u241-b08/3d5a2bb8f8d4428bbe94aed7ec7ae784/jdk-8u241-linux-x64.tar.gz
	tar -xzf /opt/jdk-8u241-linux-x64.tar.gz -C /usr/local/
	# Set java env profile
	cat >> /etc/profile << "EOF"
export JAVA_HOME=/usr/local/jdk1.8.0_241
export JRE_HOME=${JAVA_HOME}/jre
export PATH=${JAVA_HOME}/bin:$PATH
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
EOF
source /etc/profile && sleep 2
	if rpm -qa |grep glibc.i686; then
		java -version
	else
		yum -y install glibc.i686
		java -version
	fi
fi

# Install
# offcial：https://mirror.bit.edu.cn/apache/tomcat/tomcat-9/v9.0.36/bin/apache-tomcat-9.0.36.tar.gz
wget -P /opt http://mirrors.hust.edu.cn/apache/tomcat/tomcat-9/v9.0.36/bin/apache-tomcat-9.0.36.tar.gz
tar -xzf /opt/apache-tomcat-9.0.36.tar.gz -C /usr/local/
#start tomcat
#/usr/local/apache-tomcat-9.0.36/bin/startup.sh

# Create tomcat service
cat >> /etc/init.d/tomcat << "EOF"
# !/bin/bash
# Write by afei
# tomcat startup script for Tomcat Server

#chkconfig:345 80 20
#description:startup service the tomcat deamon

#Source function library
JAVA_HOME=/usr/local/apache-tomcat-9.0.36/
export JAVA_HOME
TOMCAT_HOME=/usr/local/apache-tomcat-9.0.36/
export TOMCAT_HOME

case "$1" in

start)
        echo "Starting Tomcat..."
        $TOMCAT_HOME/bin/startup.sh
        ;;
stop)
        echo "Stopping Tomcat..."
        $TOMCAT_HOME/bin/shutdown.sh
        ;;
restart)
        echo "Stopping Tomcat..."
        $TOMCAT_HOME/bin/shutdown.sh
        sleep 2
        echo
        echo "Starting Tomcat..."
        $TOMCAT_HOME/bin/startup.sh
        ;;
*)
        echo "Usage:$prog {start|stop|restart}"
        ;;
esac
exit 0
EOF
chmod +x /etc/init.d/tomcat
chkconfig --add tomcat && chkconfig tomcat on
/etc/init.d/tomcat start
netstat -antup |grep 8080