import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dart_dotenv/dart_dotenv.dart';

void main() async {
  final dotEnv = DotEnv(filePath: '../.env');
  // 打印 dotEnv 内容
  print(dotEnv);
  final key = dotEnv.get('SENDKEY');

  if (key != null) {
    final ret = await scSend('主人服务器宕机了', '第一行\n\n第二行', key);
    print(ret);
  } else {
    print('SENDKEY is not found in .env file');
  }
}

Future<String> scSend(String text, [String desp = '', String? key]) async {
  key ??= '[SENDKEY]';
  final url = 'https://sctapi.ftqq.com/$key.send';

  final request = http.MultipartRequest('POST', Uri.parse(url));
  request.fields['text'] = text;
  request.fields['desp'] = desp;

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();

  return responseBody;
}
