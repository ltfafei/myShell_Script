#!/bin/bash
# Change password strategy for Linux system
# Author：afei

echo "如不需要进行操作，直接回车跳过即可。"
read -p "请设置用户密码不过期最大天数：" A
read -p "请设置修改密码时间间隔：" B
read -p "请设置密码的最小长度：" C
read -p "请设置密码失效前多久提示：" D

sed -i "/^PASS_MAX_DAYS/c\PASS_MAX_DAYS   $A" /etc/login.defs
sed -i "/^PASS_MIN_DAYS/c\PASS_MIN_DAYS   $B" /etc/login.defs
sed -i "/^PASS_MIN_LEN/c\PASS_MIN_LEN    $C" /etc/login.defs
sed -i "/^PASS_WARN_AGE/c\PASS_WARN_AGE   $D" /etc/login.defs
echo " "
echo "密码策略设置成功！"
echo " "
sed -n '18,28p' /etc/login.defs