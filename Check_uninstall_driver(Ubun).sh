# Chack and uninstall driver
lspci | grep -i nvidia
sudo apt-get purge nvidia*
sudo apt-get autoremove
touch /etc/modprobe.d/blacklist.conf
cat >> /etc/modprobe.d/blacklist.conf << EOF
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
EOF
echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
echo "blacklist nouveau" | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
update-initramfs -u
reboot