#!/bin/bash
#Write by afei

# Judge install rely
if go version; then
	echo "go is installed! "
else
	yum -y install epel-release
	yum -y install go
	go version
fi

# Add yumrepo and install prometheus
wget -P /opt/ https://github.com/prometheus/prometheus/releases/download/v2.19.0-rc.0/prometheus-2.19.0-rc.0.linux-amd64.tar.gz
tar -xzf /opt/prometheus-2.19.0-rc.0.linux-amd64.tar.gz -C /usr/local
cd /usr/local/prometheus-2.19.0-rc.0.linux-amd64/
./prometheus --version && sleep 2

# Congura prometheus.yml
cat >> /usr/local/prometheus-2.19.0-rc.0.linux-amd64/prometheus.yml << "EOF"
  - job_name: 'node1'
    scrape_interval: 30s
    static_configs:
    - targets: ['192.168.3.155:9100']
      labels:
       instance: node1
  - job_name: 'node1-mysql'
    static_configs:
    - targets: ['192.168.3.155:9104']
      labels:
       instance: node1-mysql
	  
  - job_name: 'node2'
    scrape_interval: 30s
    static_configs:
    - targets: ['192.168.3.154:9100']
      labels:
       instance: node2
  - job_name: 'node2-mysql'
    static_configs:
    - targets: ['192.168.3.154:9104']
      labels:
       instance: node2-mysql
EOF

tail -32 prometheus.yml && sleep 2
# 启动prometheus并且后台运行
./prometheus --config.file=prometheus.yml &

# stop prometheus
#pkill -9 prometheus