import 'package:mysql1/mysql1.dart';

void main() async {
  final settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    db: 'quantum',
  );
  
  try {
    final conn = await MySqlConnection.connect(settings);
    final res = await conn.query('DESCRIBE qm_user');
    for (var row in res) {
      print('${row[0]} - ${row[1]}');
    }
    await conn.close();
  } catch (e) {
    print('Error: $e');
  }
}
