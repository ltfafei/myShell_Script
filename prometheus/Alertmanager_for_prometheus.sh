#!/bin/bash
# Write by afei

wget -P /opt https://github.com/prometheus/alertmanager/releases/download/v0.21.0-rc.0/alertmanager-0.21.0-rc.0.linux-amd64.tar.gz
tar -xzf /opt/alertmanager-0.21.0-rc.0.linux-amd64.tar.gz -C /usr/local/
cd /usr/local/alertmanager-0.21.0-rc.0.linux-amd64/
mv alertmanager.yml alertmanager.yml.bak

# 邮箱告警配置
cat >> /usr/local/alertmanager-0.21.0-rc.0.linux-amd64/alertmanager.yml << "EOF"
global:
  resolve_timeout: 3m
  smtp_smarthost: 'smtp.163.com:25'
  smtp_from: 'm18479685120@163.com'
  smtp_auth_username: 'm18479685120@163.com'
  smtp_auth_password: 'XLTIYNLTWPALVTQB'
  smtp_require_tls: false

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1m
  receiver: 'mail'

receivers:
- name: 'mail'
  webhook_configs:
  - to: 'm18479685120@163.com'
  
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']
EOF

./amtool check-config alertmanager.yml   #检查altermanager.yml配置文件

# Create alertmanager service
cat >> /usr/lib/systemd/system/alertmanager.service << "EOF"
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/download/#alertmanager
After=network.target

[Service]
设置为simple时，ExecStart=进程 就是该服务的主进程
Type=simple  
User=root
ExecStart=/usr/local/alertmanager-0.21.0-rc.0.linux-amd64/alertmanager --config.file=/usr/local/alertmanager-0.21.0-rc.0.linux-amd64/alertmanager.yml
Restart=on-failure
ExecStop=/bin/kill -WINCH ${MAINPID}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start alertmanager
systemctl enable alertmanager
systemctl status alertmanager
