#!/bin/bash
# Write by afei
# Original: Foreign boy

#lazy find

##############
# print help
##############

function hel {
	echo " "
	echo "快速模糊搜索当前目录文件"
	echo "用法: $0 [--match-case|--path] filename"
	echo "
参数：
	-m --match-case    区分大小写匹配；
	-p --path          指定搜索路径。
	"
	echo " "
	exit
}

# set variables
MATCH="-iname"
SEARCH="."

# parameter options
while [ True ]; do
if [ "$1" = "--help" -o "$1" =  "-h" ]; then
	hel
elif [ "$1" = "--match-case" -o "$1" = "-m" ]; then
	MATCH="-name"
	shift 1
elif [ "$1" = "--path" -o "$1" = "-p" ]; then
	SEARCH="${2}"
	shift 2
else
	break
fi
done

############################
# 输入文件，创建数组，保留空间
############################

ARG=( "${@}" ) 
set -e  #一旦出现了返回值非零，整个脚本就会立即退出

# 捕捉异常
if [ "X$ARG" = "X" ]; then
	hel
fi

## perform serarch

for query in ${ARG[*]}; do
	/usr/bin/find "${SEARCH}" "${MATCH}" "*${ARG}*"
done