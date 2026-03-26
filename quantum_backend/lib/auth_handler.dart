import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:crypt/crypt.dart';
import 'package:bcrypt/bcrypt.dart';
import 'db.dart';

const jwtSecret = 'super_secret_quantum_key_123';

class AuthHandler {
  Router get router {
    final router = Router();
    router.post('/login', _login);
    router.post('/register', _register);
    return router;
  }

  Future<Response> _login(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = json.decode(payload);
      final String login = data['login'] ?? '';
      final String password = data['password'] ?? '';

      if (login.isEmpty || password.isEmpty) {
        return Response.badRequest(body: json.encode({'error': 'login and password required'}));
      }

      final res = await Database.pool.query(
        "SELECT id, login, password_hash FROM qm_user WHERE login = ?",
        [login],
      );

      if (res.isEmpty) {
        return Response.forbidden(json.encode({'error': 'Invalid credentials'}));
      }

      final user = res.first;
      final storedHash = user.fields['password_hash']?.toString() ?? '';
      
      bool isMatch = false;
      
      if (storedHash.startsWith('\$2')) {
        // Format of BCrypt ($2a$, $2b$, etc)
        try {
          isMatch = BCrypt.checkpw(password, storedHash);
        } catch (e) {
          isMatch = false;
        }
      } else if (storedHash.contains('\$')) {
        // POSIX crypt format ($1$, $5$, etc)
        try {
          final crypt = Crypt(storedHash);
          isMatch = crypt.match(password);
        } catch (e) {
          isMatch = false;
        }
      } else {
        // Fallback for plain text
        isMatch = password == storedHash;
      }

      if (!isMatch) {
        return Response.forbidden(json.encode({'error': 'Invalid credentials'}));
      }
      
      final jwt = JWT({
        'id': user.fields['id'],
        'login': login,
        'role': 'user',
      });

      final token = jwt.sign(SecretKey(jwtSecret));

      return Response.ok(json.encode({
        'token': token,
        'user': {
          'id': user.fields['id'],
          'login': login,
        }
      }), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: json.encode({'error': e.toString()}));
    }
  }

  Future<Response> _register(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = json.decode(payload);
      final String login = data['login'] ?? '';
      final String email = data['email'] ?? '';
      final String password = data['password'] ?? '';

      if (login.isEmpty || email.isEmpty || password.isEmpty) {
        return Response.badRequest(body: json.encode({'error': 'login, email and password required'}));
      }

      final checkExist = await Database.pool.query(
        "SELECT id FROM qm_user WHERE login = ? OR email = ?",
        [login, email],
      );

      if (checkExist.isNotEmpty) {
        return Response.badRequest(body: json.encode({'error': 'User already exists'}));
      }

      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      await Database.pool.query(
        "INSERT INTO qm_user (login, email, password_hash, activated, lang_key, created_by, created_date) VALUES (?, ?, ?, 1, 'es', 'system', NOW())",
        [login, email, hashedPassword],
      );

      return Response.ok(json.encode({'message': 'User registered successfully'}), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: json.encode({'error': e.toString()}));
    }
  }
}
