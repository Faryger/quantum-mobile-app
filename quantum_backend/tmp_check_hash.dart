import 'package:crypt/crypt.dart';
void main() {
  final h = Crypt.sha256('mypassword').toString();
  print('Hash length: ${h.length}');
  print('Hash: $h');
}
