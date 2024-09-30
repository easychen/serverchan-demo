<?php

$data = parse_ini_file(__DIR__ . '/../.env');
$key = $data['SENDKEY'];

$ret = sc_send('主人服务器宕机了', "第一行\n\n第二行", $key);
echo $ret;

function sc_send($text, $desp = '', $key = '[SENDKEY]')
{
    $postdata = http_build_query(array( 'text' => $text, 'desp' => $desp ));
    // 判断 $key 是否以 'sctp' 开头，并拼接相应的 URL
    if (strpos($key, 'sctp') === 0) {
        $url = "https://{$key}.push.ft07.com/send";
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
