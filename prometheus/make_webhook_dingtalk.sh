#!/bin/bash
# Write by afei

# Wget dingtalk
wget -P /opt/ https://github.com/timonwong/prometheus-webhook-dingtalk/releases/download/v1.4.0/prometheus-webhook-dingtalk-1.4.0.linux-amd64.tar.gz
tar -xzf /opt/prometheus-webhook-dingtalk-1.4.0.linux-amd64.tar.gz -C /usr/local
cd /usr/local/prometheus-webhook-dingtalk-1.4.0.linux-amd64

# Binding dingtalk and startxxxxxxxxxxxxxxx7bee08dxxxxxxxxxxx1" &

# Create dingtalk service
cat >> /usr/lib/systemd/system/dingtalk.service << "EOF"
# Write by afei

[Unit]
Description=prometheus-webhook-dingtalk
Documentation=https://github.com/timonwong/prometheus-webhook-dingtalk/
After=network.target

[Service]
Type=simple  
User=root
ExecStart=/usr/local/prometheus-webhook-dingtalk-1.4.0.linux-amd64/prometheus-webhook-dingtalk --ding.profile="webhook1=https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxxxxxxxx78bc6xxxx"
Restart=on-failure
ExecStop=/bin/kill -WINCH ${MAINPID}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start dingtalk && systemctl enable dingtalk
systemctl status dingtalk
netstat -nltup |grep dingtalk