#!/bin/bash

Font_Green="\033[32m"
Font_Red="\033[31m"
Font_Suffix="\033[0m"

check_vpn() {
    url=$1
    keyword=$2
    type=$3

    # 发送请求并获取页面内容
    response=$(curl -s "$url")

    # 检查页面内容是否包含关键字
    if echo "$response" | grep -q "$keyword"; then
        printf "\r %-20s:\t${Font_Red}No${Font_Suffix}\n" "${type}_ChatGPT"
    else
        printf "\r %-20s:\t${Font_Green}Yes${Font_Suffix}\n" "${type}_ChatGPT"
    fi
}

# 检查 Web ChatGPT
check_vpn "https://api.openai.com/" "error" "Web"

# 检查 iOS ChatGPT
check_vpn "https://ios.chat.openai.com/" "VPN" "iOS"

# 检查 Android ChatGPT
check_vpn "https://android.chat.openai.com/" "VPN" "Android"
