import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
void main() async {
  print('TESTING empty password...');
  try {
    final conn = await MySQLConnection.createConnection(host: '127.0.0.1', port: 3306, userName: 'root', password: '', secure: false);
    await conn.connect();
    print('SUCCESS WITH EMPTY PASSWORD!');
    exit(0);
  } catch(e) {
    print('Failed empty: ' + e.toString());
  }

  print('TESTING root password...');
  try {
    final conn2 = await MySQLConnection.createConnection(host: '127.0.0.1', port: 3306, userName: 'root', password: 'root', secure: false);
    await conn2.connect();
    print('SUCCESS WITH ROOT PASSWORD!');
    exit(0);
  } catch(e) {
    print('Failed root: ' + e.toString());
  }
  
  print('TESTING LOCALHOST empty...');
  try {
    final conn3 = await MySQLConnection.createConnection(host: 'localhost', port: 3306, userName: 'root', password: '', secure: false);
    await conn3.connect();
    print('SUCCESS WITH LOCALHOST EMPTY!');
    exit(0);
  } catch(e) {
    print('Failed localhost empty: ' + e.toString());
  }

  exit(1);
}
