#!/bin/bash
# Change user for Linux system
# Author：afei

echo "从以下可登录账号进行选择操作！"
echo -------------------------------
cat /etc/passwd |grep -v "nologin"
echo " "
echo "如不需要进行操作，直接回车跳过即可。"
read -p "请输入需要删除的无用账号：" A
read -p "请输入需要锁定的账号(锁定之后用户不能修改密码哦！)：" B
read -p "请输入需要解锁的账号：" C
read -p "请输入需要查看的账号：" D

userdel -r $A 2>/dev/null
passwd -l $B 2>/dev/null
passwd -u $C 2>/dev/null
passwd -S $D 2>/dev/null