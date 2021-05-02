#!/bin/bash
# Write by afei

# Upload jdk-8.0 and Burpsuite files
cd /opt && tar -xzf jdk-8u241-linux-x64.tar.gz
mv jdk1.8.0_241/ /usr/local/jdk1.8

echo >> /etc/profile.d/java.sh << "EOF"
# JAVA JDK profile
export JAVA_HOME=/usr/local/jdk1.8
export CLASSPATH=.:${JAVA_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
EOF

source /etc/profile.d/java.sh && sleep 3

java --version && sleep 1
rm /usr/bin/java && rm /usr/bin/javac
ln -s /usr/local/jdk1.8/bin/java /usr/bin/java
ln -s /usr/local/jdk1.8/bin/javac /usr/bin/javac
java -version && sleep 2