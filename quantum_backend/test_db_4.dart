import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
void main() async {
  final out = File('out4.txt').openWrite();
  try {
     final conn = await MySQLConnection.createConnection(host: '127.0.0.1', port: 3306, userName: 'root', secure: false);
     await conn.connect();
     out.writeln('127.0.0.1 OMIT PASS');
     await conn.close();
  } catch(e) { out.writeln('127.0.0.1 OMIT FAIL: ' + e.toString()); }
  try {
     final conn3 = await MySQLConnection.createConnection(host: 'localhost', port: 3306, userName: 'root', secure: false);
     await conn3.connect();
     out.writeln('localhost OMIT PASS');
     await conn3.close();
  } catch(e) { out.writeln('localhost OMIT FAIL: ' + e.toString()); }
  await out.close();
  exit(0);
}
