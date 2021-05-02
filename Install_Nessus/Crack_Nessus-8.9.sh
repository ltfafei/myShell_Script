#!/bin/bash
# Write by afei

cd /opt/Nessus-8.9.1 && ls
/opt/nessus/sbin/nessuscli update all-2.0.tar.gz

find /opt -name plugin_feed_info.inc
cat /opt/nessus/var/nessus/plugin_feed_info.inc
cat /opt/nessus/lib/nessus/plugins/plugin_feed_info.inc && sleep 2

echo >> /opt/nessus/var/nessus/plugin_feed_info.inc << "EOF"
PLUGIN_ SET = "202006091543";
PLUGIN_ FEED = "ProfessionalFeed (Direct)";
PLUGIN_ FEED_ _TRANSPORT = "Tenable Network Security Lightning";
EOF

echo >> /opt/nessus/lib/nessus/plugins/plugin_feed_info.inc << "EOF"
PLUGIN_ SET = "202006091543";
PLUGIN_ FEED = "ProfessionalFeed (Direct)";
PLUGIN_ FEED_ _TRANSPORT = "Tenable Network Security Lightning";
EOF

systemctl restart nessusd && systemctl status nessusd

echo " "
echo "Nessus已破解，可以正常使用了"