import os
import urllib.parse
import urllib.request

def sc_send(text, desp='', key='[SENDKEY]'):
    postdata = urllib.parse.urlencode({'text': text, 'desp': desp}).encode('utf-8')
    url = f'https://sctapi.ftqq.com/{key}.send'
    req = urllib.request.Request(url, data=postdata, method='POST')
    with urllib.request.urlopen(req) as response:
        result = response.read().decode('utf-8')
    return result

data = {}
with open(os.path.join(os.path.dirname(__file__), '..', '.env'), 'r') as f:
    for line in f:
        key, value = line.strip().split('=')
        data[key] = value
key = data['SENDKEY']

ret = sc_send('主人服务器宕机了', '第一行\n\n第二行', key)
print(ret)