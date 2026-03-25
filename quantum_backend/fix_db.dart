import 'package:mysql1/mysql1.dart';

void main() async {
  final settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    db: 'quantum',
  );
  
  final conn = await MySqlConnection.connect(settings);

  // Check rows
  var res = await conn.query("SELECT id, login FROM qm_user");
  print("Current users before fix:");
  for (var row in res) {
    print("id: ${row[0]}, login: ${row[1]}");
  }

  // Delete testuser2 to free up 0 and fix duplicates
  await conn.query("DELETE FROM qm_user WHERE login = 'testuser2'");

  try {
    await conn.query("ALTER TABLE qm_user MODIFY id BIGINT(20) AUTO_INCREMENT");
    print("Successfully added AUTO_INCREMENT to id");
  } catch (e) {
    print("Failed to alter BIGINT table: $e");
    try {
      await conn.query("ALTER TABLE qm_user MODIFY id INT AUTO_INCREMENT");
      print("Successfully added AUTO_INCREMENT (INT) to id");
    } catch (e2) {
      print("Failed to alter INT table: $e2");
    }
  }
  
  await conn.close();
}
