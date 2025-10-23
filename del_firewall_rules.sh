#!/bin/bash

# 获取带编号的UFW规则（含编号）
rules=$(sudo ufw status numbered)

# 显示规则列表
echo "$rules"

# 读取要删除的IP地址
read -p "请输入要删除规则的IP地址: " delete_ip

# 验证输入
if [[ ! $delete_ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo -e "\e[31m无效的IP地址。\e[0m"
  exit 1
fi

# 查找匹配该IP的规则编号（倒序防止删除后编号变化）
rule_numbers=$(echo "$rules" | grep "$delete_ip" | grep -oP '(?<=\[ )\d+(?=\])' | sort -rn)

if [ -z "$rule_numbers" ]; then
  echo -e "\e[33m未找到包含该IP的规则。\e[0m"
  exit 0
fi

# 删除匹配的规则
for num in $rule_numbers; do
  echo -e "\e[36m正在删除规则编号: $num\e[0m"
  sudo ufw --force delete "$num"
done

echo -e "\e[32m已删除所有匹配IP地址的规则。\e[0m"
