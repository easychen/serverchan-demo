import os
import requests

def sc_send(sendkey, title, desp='', options=None):
    if options is None:
        options = {}
    if sendkey.startswith('sctp'):
        url = f'https://{sendkey}.push.ft07.com/send'
    else:
        url = f'https://sctapi.ftqq.com/{sendkey}.send'
    params = {
        'title': title,
        'desp': desp,
        **options
    }
    headers = {
        'Content-Type': 'application/json;charset=utf-8'
    }
    response = requests.post(url, json=params, headers=headers)
    result = response.json()
    return result


data = {}
with open(os.path.join(os.path.dirname(__file__), '..', '.env'), 'r') as f:
    for line in f:
        key, value = line.strip().split('=')
        data[key] = value
key = data['SENDKEY']

ret = sc_send(key, '主人服务器宕机了', '第一行\n\n第二行')
print(ret)