#!/bin/bash
#Write by afei

wget -P /opt https://github.com/hnlq715/nginx-vts-exporter/releases/download/v0.10.3/nginx-vts-exporter-0.10.3.linux-amd64.tar.gz
tar -xzf /opt/nginx-vts-exporter-0.10.3.linux-amd64.tar.gz -C /usr/local/

# Create nginx_VTS_exporter
cat >> /usr/lib/systemd/system/nginxvts_exporter.service << "EOF"
[Unit]
Description=nginx-vts-exporter
Documentation=https://github.com/hnlq715/nginx-vts-exporter
After=network.target

[Service]
#设置为simple时，ExecStart=进程 就是该服务的主进程
Type=simple  
User=root
ExecStart=/usr/local/nginx-vts-exporter-0.10.3.linux-amd64/nginx-vts-exporter -nginx.scrape_uri=http://127.0.0.1/server-status/format/json
Restart=on-failure
ExecStop=/bin/kill -WINCH ${MAINPID}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start nginxvts_exporter && systemctl status nginxvts_exporter
systemctl enable nginxvts_exporter
netstat -nltup |grep nginx-vts
