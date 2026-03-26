import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:quantum_backend/api_handler.dart';
import 'package:quantum_backend/auth_handler.dart';
import 'package:quantum_backend/db.dart';

Middleware cors() => (innerHandler) => (request) async {
  final headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, X-Requested-With, Content-Type, Accept, Authorization',
  };
  
  if (request.method == 'OPTIONS') {
    return Response.ok('', headers: headers);
  }
  final response = await innerHandler(request);
  return response.change(headers: headers);
};

Middleware checkToken() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.url.path.startsWith('auth/')) {
        return innerHandler(request);
      }

      final authHeader = request.headers['Authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.forbidden('Missing or invalid Authorization header');
      }

      final token = authHeader.substring(7);
      try {
        JWT.verify(token, SecretKey(jwtSecret));
        return innerHandler(request);
      } catch (e) {
        return Response.forbidden('Invalid token');
      }
    };
  };
}

void main(List<String> args) async {
  await Database.init();

  final router = Router();
  
  final authHandler = AuthHandler();
  router.mount('/auth', authHandler.router.call);
  
  final apiHandler = ApiHandler();
  router.mount('/api', apiHandler.router.call);

  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(cors())
      .addMiddleware(checkToken())
      .addHandler(router.call);

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8085');
  
  final server = await serve(pipeline, ip, port);
  print('Server listening on port ${server.port}');
}
