<?php

$data = parse_ini_file(__DIR__ . '/../.env');
$key = $data['SENDKEY'];

$ret = sc_send('主人服务器宕机了 via PHP', "第一行\n\n第二行", $key);
echo $ret;

function sc_send($text, $desp = '', $key = '[SENDKEY]')
{
    $postdata = http_build_query(array( 'text' => $text, 'desp' => $desp ));

    // 判断 $key 是否以 'sctp' 开头，并根据匹配到的数字部分拼接相应的 URL
    if (strpos($key, 'sctp') === 0) {
        // 使用正则表达式提取 sctp 开头后面的数字
        preg_match('/^sctp(\d+)t/', $key, $matches);
        $num = $matches[1];
        $url = "https://{$num}.push.ft07.com/send/{$key}.send";
    } else {
        $url = "https://sctapi.ftqq.com/{$key}.send";
    }

    $opts = array('http' =>
    array(
        'method'  => 'POST',
        'header'  => 'Content-type: application/x-www-form-urlencoded',
        'content' => $postdata));

    $context  = stream_context_create($opts);
    return $result = file_get_contents($url, false, $context);
    ;

}
