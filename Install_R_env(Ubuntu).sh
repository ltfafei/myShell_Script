#!/bin/bash
# Write by afei

if ! which R; then
	echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" >> /etc/apt/sources.list
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
	apt-get update
	apt-get install -y r-base r-base-dev
	R --version
else
	R --version
	exit 1
fi