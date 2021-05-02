#!/bin/bash
# Write by afei

# Edit hosts file
cat >> /etc/hosts EOF
10.0.2.210 mgt mgt.openhpc.com
10.0.2.208 storage
10.0.2.206 node001
10.0.2.204 node002
10.0.2.202 node003
10.0.2.200 node004
10.0.2.198 node005
10.0.2.196 node006

10.10.13.10 mgt-ib
10.10.13.200 storage-ib
10.10.13.100 node001-ib
10.10.13.101 node002-ib
10.10.13.102 node003-ib
10.10.13.103 node004-ib
10.10.13.104 node005-ib
10.10.13.105 node006-ib
EOF

# Configure ssh no-pass
ssh-keygen -t rsa
ssh-copy-id mgt
ssh-copy-id storage
ssh-copy-id node001
ssh-copy-id node002
ssh-copy-id node003
ssh-copy-id node004
ssh-copy-id node005
ssh-copy-id node006