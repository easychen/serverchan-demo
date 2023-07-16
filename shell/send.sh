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

    result=$(curl -X POST -s -o /dev/null -w "%{http_code}" "https://sctapi.ftqq.com/$key.send" "${opts[@]}")
    echo "$result"
}

# 读取配置文件
data=$(cat "$PWD/../.env")
eval "$data"

# 调用sc_send函数
ret=$(sc_send '主人服务器宕机了' $'第一行\n\n第二行' "$SENDKEY")
echo "$ret"

