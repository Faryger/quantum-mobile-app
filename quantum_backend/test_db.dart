import 'package:mysql_client/mysql_client.dart';

void main() async {
  final pool = await MySQLConnectionPool(
    host: '127.0.0.1',
    port: 3306,
    userName: 'root',
    password: '',
    databaseName: 'quantum',
    maxConnections: 1,
  );
  var res = await pool.execute("SELECT id, login, password_hash FROM qm_user");
  for (var row in res.rows) {
    print(row.assoc());
  }
  await pool.close();
}
