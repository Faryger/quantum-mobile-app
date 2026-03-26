import 'package:mysql_client/mysql_client.dart';

void main() async {
  try {
    List<String> passwords = ["", "root", "password"];
    MySQLConnection? conn;
    
    for (var pwd in passwords) {
      try {
        print("Trying password: '${pwd}'");
        conn = await MySQLConnection.createConnection(
          host: "127.0.0.1",
          port: 3306,
          userName: "root",
          password: pwd,
          databaseName: "quantum",
        );
        await conn.connect();
        print("Connected with password: '${pwd}'");
        break;
      } catch (e) {
        print("Failed with '${pwd}': ${e}");
        conn = null;
      }
    }
    
    if (conn == null || !conn.connected) {
      print("Could not connect with any password via 127.0.0.1.");
      return;
    }

    final result = await conn.execute("SHOW TABLES");
    List<String> tables = [];
    for (final row in result.rows) {
      if (row.colAt(0) != null) {
        tables.add(row.colAt(0)!);
      }
    }

    print("Tables found: ${tables}");
    for (String table in tables) {
      print("--- Schema for ${table} ---");
      final desc = await conn.execute("DESCRIBE `${table}`");
      for (final row in desc.rows) {
        print("${row.colByName('Field')} | ${row.colByName('Type')} | PRI: ${row.colByName('Key') == 'PRI'}");
      }
    }

    await conn.close();
  } catch (e) {
    print("Fatal Error: ${e}");
  }
}
