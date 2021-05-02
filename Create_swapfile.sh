#!/bin/bash
# Original: yuanqiangfei
# Write by afei

# 查看swap
free
echo "------------Start add swapfile----------------"

# 创建一个交换文件(交换分区)
ROOT_UID=0 # Root 用户的 $UID 是 0.
WRONG_USER=65  #判断是否是root用户
FILE=/swapfile1 
BLSIZE=2048000   #(BLSIZE * MINBLO)是字节数
MINBLO=500   #指定默认数据块数量，至少40个数据块，不然无法创建成功

# 这个脚本必须用root来运行.
if [ "$UID" -ne "$ROOT_UID" ]
  then
  echo "------------------------------------------------------"
  echo "You not root, please use root user run this script!!!"
  echo "------------------------------------------------------"
  exit $WRONG_USER
fi
blocks=${1:-$MINBLO} # 如果命令行中没有指定，则会默认为设置的500块
# 第18行语句等同21-26行：
# -------------------------------------
if [ -n "$1" ]
then
blocks=$1
else
blocks=$MINBLO
fi
# -------------------------------------
if [ "$blocks" -lt $MINBLO ]
then
blocks=$MINBLO
fi
echo "Creating swap file of size $blocks blocks (KB)."
dd if=/dev/zero of=$FILE bs=$BLSIZE count=$blocks # 把0写入文件.
mkswap $FILE $blocks # 将此文件格式化为交换文件.
swapon $FILE # 挂载交换分区
echo "Swap file successfully mount."

free