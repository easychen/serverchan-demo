#!/bin/bash

function sc_send() {
    local text=$1
    local desp=$2
    local key=$3

    postdata="text=$text&desp=$desp"
    opts=(
        "--header" "Content-type: application/x-www-form-urlencoded"
        "--data" "$postdata"
    )

    # 判断 key 是否以 "sctp" 开头，选择不同的 URL
    if [[ "$key" == sctp* ]]; then
        url="https://${key}.push.ft07.com/send"
    else
        url="https://sctapi.ftqq.com/${key}.send"
    fi

    # 使用动态生成的 url 发送请求
    result=$(curl -X POST -s -o /dev/null -w "%{http_code}" "$url" "${opts[@]}")
    echo "$result"
}

# 读取配置文件
data=$(cat "$PWD/../.env")
eval "$data"

# 调用sc_send函数
ret=$(sc_send '主人服务器宕机了' $'第一行\n\n第二行' "$SENDKEY")
echo "$ret"

