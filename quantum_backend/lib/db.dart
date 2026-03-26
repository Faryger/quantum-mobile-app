import 'package:mysql1/mysql1.dart';

class Database {
  static MySqlConnection? _pool;

  static Future<void> init() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      db: 'quantum',
    );
    
    _pool = await MySqlConnection.connect(settings);
    print("Database connection initialized.");
  }

  static MySqlConnection get pool {
    if (_pool == null) throw Exception("DB not initialized");
    return _pool!;
  }
}
