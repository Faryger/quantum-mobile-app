import 'dart:io';
import 'dart:convert';
void main() async {
  final hc = HttpClient();
  try {
    final req = await hc.post('127.0.0.1', 8085, '/auth/login');
    req.headers.add('Content-Type', 'application/json');
    req.write(json.encode({"login":"admin","password":"a"}));
    final res = await req.close();
    final body = await res.transform(utf8.decoder).join();
    File('out2.txt').writeAsStringSync('HTTP ' + res.statusCode.toString() + '\nBODY: ' + body);
  } catch(e) {
    File('out2.txt').writeAsStringSync('Error: ' + e.toString());
  }
  exit(0);
}
