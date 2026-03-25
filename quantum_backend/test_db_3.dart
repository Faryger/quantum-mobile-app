import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
void main() async {
  final out = File('out3.txt').openWrite();
  try {
     final conn = await MySQLConnection.createConnection(host: '127.0.0.1', port: 3306, userName: 'root', password: '', secure: false);
     await conn.connect();
     out.writeln('127.0.0.1 empty PASS');
     await conn.close();
  } catch(e) { out.writeln('127.0.0.1 empty FAIL: ' + e.toString()); }
  try {
     final conn2 = await MySQLConnection.createConnection(host: '127.0.0.1', port: 3306, userName: 'root', password: 'root', secure: false);
     await conn2.connect();
     out.writeln('127.0.0.1 root PASS');
     await conn2.close();
  } catch(e) { out.writeln('127.0.0.1 root FAIL: ' + e.toString()); }
  try {
     final conn3 = await MySQLConnection.createConnection(host: 'localhost', port: 3306, userName: 'root', password: '', secure: false);
     await conn3.connect();
     out.writeln('localhost empty PASS');
     await conn3.close();
  } catch(e) { out.writeln('localhost empty FAIL: ' + e.toString()); }
  try {
     final conn4 = await MySQLConnection.createConnection(host: 'localhost', port: 3306, userName: 'root', password: 'root', secure: false);
     await conn4.connect();
     out.writeln('localhost root PASS');
     await conn4.close();
  } catch(e) { out.writeln('localhost root FAIL: ' + e.toString()); }
  await out.close();
  exit(0);
}
