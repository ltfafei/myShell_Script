#!/bin/bash
# Write by afei

# 1.install Tasla 440
#wget http://cn.download.nvidia.com/tesla/440.64.00/NVIDIA-Linux-x86_64-440.64.00.run

touch /etc/modprobe.d/blacklist.conf
cat >> /etc/modprobe.d/blacklist.conf << EOF
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
EOF

echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
yum -y install gcc kernel-devel kernel-headers
#yum update
#mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.bak
#dracut -v /boot/initramfs-$(uname -r).img $(uname -r)
#reboot
systemctl stop gdm
sleep 2
chmod +x NVIDIA-Linux-x86_64-440.64.00.run
./NVIDIA-Linux-x86_64-440.64.00.run