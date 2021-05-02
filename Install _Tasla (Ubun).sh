if ! lsmod | grep nouveau; then
	wget http://cn.download.nvidia.com/tesla/440.64.00/NVIDIA-Linux-x86_64-440.64.00.run
	apt-get install -y build-essential cmake git unzip zip python-dev python3-dev python-pip python3-pip gcc linux-source
	./NVIDIA-Linux-x86_64-440.64.00.run
fi
	echo "please run Check_uninstall_driver.sh and reboot！"