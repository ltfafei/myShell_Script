#!/bin/bash
#Write by afei

cat >> /etc/yum.repos.d/grafana.repo << "EOF"
[grafana]
name=grafana
baseurl=https://packages.grafana.com/enterprise/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

yum makecache
sudo yum -y install grafana-enterprise

# Add grafana worldping_plugin
grafana-cli plugins install raintank-worldping-app

# Start and enable Grafana
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl status grafana-server
sudo systemctl enable grafana-server
netstat -nltup |grep grafana