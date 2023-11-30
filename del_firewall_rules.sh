#!/bin/bash

# 列出带编号的UFW规则
ufw status numbered

# 提示用户输入要删除的IP地址
read -p "请输入要删除规则的IP地址: " delete_ip

# 验证输入是否为有效的IP地址
if [[ ! $delete_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo -e "\e[31m无效的IP地址。脚本终止。\e[0m"
  exit 1
fi

# 获取所有带有指定IP地址的规则，提取端口信息
matching_rules=$(ufw status numbered | grep "$delete_ip" | awk '{print $2}')

# 遍历并删除所有匹配的规则
for rule_ports in $matching_rules; do
  # 提取端口号
  IFS=',' read -ra ports <<< "$rule_ports"
  
  # 遍历并删除每个端口的规则
  for port in "${ports[@]}"; do
    sudo ufw delete allow from "$delete_ip" to any port "$port"
  done
done

echo -e "\e[32m已删除所有匹配IP地址的规则。\e[0m"
