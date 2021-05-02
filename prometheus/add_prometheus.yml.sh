#!/bin/bash
# Write by afei

#-----------------------------------
# Add apache host to prometheus.yml
#-----------------------------------
cat >> /usr/local/prometheus-2.19.0-rc.0.linux-amd64/prometheus.yml << "EOF"
  - job_name: 'node1-apache'
    scrape_interval: 30s
    static_configs:
    - targets: ['192.168.3.155:9117']
      labels:
       instance: node1-apache
EOF

#-----------------------------------
# Add nginx host to prometheus.yml
#-----------------------------------
cat >> /usr/local/prometheus-2.19.0-rc.0.linux-amd64/prometheus.yml << "EOF"
  - job_name: 'node2-nginx'
    scrape_interval: 30s
    static_configs:
    - targets: ['192.168.3.154:9113']
      labels:
       instance: node2-nginx
EOF

#-----------------------------------
# Add tomcat host to prometheus.yml
#-----------------------------------
cat >> /usr/local/prometheus-2.19.0-rc.0.linux-amd64/prometheus.yml << "EOF"
  - job_name: 'node2-tomcat'
    scrape_interval: 30s
    static_configs:
    - targets: ['192.168.3.154:9999']
      labels:
       instance: node2-tomcat
EOF

cd /usr/local/prometheus-2.19.0-rc.0.linux-amd64
./promtool check config prometheus.yml 
systemctl restart prometheus && systemctl status prometheus