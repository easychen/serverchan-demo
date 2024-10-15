import 'package:http/http.dart' as http;
import 'package:dart_dotenv/dart_dotenv.dart';

void main() async {
  final dotEnv = DotEnv(filePath: '../.env');
  // 打印 dotEnv 内容
  print(dotEnv);
  final key = dotEnv.get('SENDKEY') ?? '';

  if (key != null) {
    final ret = await scSend('主人服务器宕机了 via dart', '第一行\n\n第二行', key);
    print(ret);
  } else {
    print('SENDKEY is not found in .env file');
  }
}

Future<String> scSend(String text, [String desp = '', String? key]) async {
  key = key ?? '[SENDKEY]';
  String url;
  if (key.startsWith('sctp')) {
    final regExp = RegExp(r'sctp(\d+)t');
    final match = regExp.firstMatch(key);
    if (match != null) {
      final num = match.group(1); // 提取数字部分
      url = 'https://$num.push.ft07.com/send/$key.send';
    } else {
      throw ArgumentError('Invalid key format');
    }
  } else {
    url = 'https://sctapi.ftqq.com/$key.send';
  }

  final request = http.MultipartRequest('POST', Uri.parse(url));
  request.fields['text'] = text;
  request.fields['desp'] = desp;

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();

  return responseBody;
}
