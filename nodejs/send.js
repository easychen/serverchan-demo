const https = require('https');
const querystring = require('querystring');
const fs = require('fs');
const path = require('path');

const data = require('dotenv').parse(fs.readFileSync( path.join(__dirname, '../.env') ));
const key = data.SENDKEY;

(async () => {
    const ret = await sc_send('主人服务器宕机了', "第一行\n\n第二行", key);
    console.log(ret);
})();

async function sc_send(text, desp = '', key = '[SENDKEY]') {
    const postData = querystring.stringify({ text, desp });
    // 根据 sendkey 是否以 'sctp' 开头，选择不同的 API URL
    const url = String(key).startsWith('sctp') 
        ? `https://${key}.push.ft07.com/send`
        : `https://sctapi.ftqq.com/${key}.send`;
  
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(postData)
      },
      body: postData
    });
  
    const data = await response.text();
    return data;
  }