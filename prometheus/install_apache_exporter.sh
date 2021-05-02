#!/bin/bash
# Write by afei

wget -P /opt/ https://github.com/Lusitaniae/apache_exporter/releases/download/v0.8.0/apache_exporter-0.8.0.linux-amd64.tar.gz
tar -xzf /opt/apache_exporter-0.8.0.linux-amd64.tar.gz -C /usr/local

# Create appche_exporter service
cat >> /usr/lib/systemd/system/apache_exporter.service << "EOF"
# Write by afei

[Unit]
Description=apache_exporter
Documentation=https://github.com/Lusitaniae/apache_exporter
After=network.target

[Service]
Type=simple  
User=root
ExecStart=/usr/local/apache_exporter-0.8.0.linux-amd64/apache_exporter
Restart=on-failure
ExecStop=/bin/kill -WINCH ${MAINPID}

[Install]
WantedBy=multi-user.target
EOF

yum -y install httpd

# Add apache module
cat >> /etc/httpd/conf/httpd.conf << "EOF"
LoadModule status_module modules/mod_status.so
<location /apache-status>
    SetHandler server-status
    Order Deny,Allow
    Deny from nothing
    Allow from all
</location>
EOF

systemctl start httpd && systemctl enable httpd
systemctl status httpd
systemctl daemon-reload
systemctl start apache_exporter  && systemctl enable apache_exporter
systemctl status apache_exporter
netstat -nltup |grep apache_exporte