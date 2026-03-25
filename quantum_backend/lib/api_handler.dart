import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql1/mysql1.dart';
import 'db.dart';

class ApiHandler {
  Router get router {
    final router = Router();
    router.get('/contract', _getContracts);
    router.get('/attendance', _getAttendance);
    router.get('/journey', _getJourney);
    router.get('/permission', _getPermissions);
    router.get('/schedule', _getSchedule);
    router.get('/shift', _getShift);
    router.get('/support', _getSupport);
    return router;
  }

  Future<Response> _getContracts(Request req) async => _fetch("SELECT * FROM contract");
  Future<Response> _getAttendance(Request req) async => _fetch("SELECT * FROM attendance");
  Future<Response> _getJourney(Request req) async => _fetch("SELECT * FROM journey");
  Future<Response> _getSchedule(Request req) async => _fetch("SELECT * FROM schedule");
  Future<Response> _getShift(Request req) async => _fetch("SELECT * FROM shift");
  Future<Response> _getSupport(Request req) async => _fetch("SELECT * FROM support");

  Future<Response> _getPermissions(Request req) async {
    final query = """
      SELECT p.*, up.traceability, up.user_data_id
      FROM permission p
      LEFT JOIN user_permission up ON p.id = up.permission_id
    """;
    return _fetch(query);
  }

  Future<Response> _fetch(String query) async {
    try {
      final res = await Database.pool.query(query);
      return Response.ok(json.encode(_mapResultSet(res)), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: json.encode({'error': e.toString()}));
    }
  }

  List<Map<String, dynamic>> _mapResultSet(Results result) {
    List<Map<String, dynamic>> mapped = [];
    for (final row in result) {
      final map = <String, dynamic>{};
      row.fields.forEach((k, v) {
        if (v is Blob) {
          map[k] = v.toString(); // safe serialization
        } else if (v is DateTime) {
          map[k] = v.toIso8601String();
        } else {
          map[k] = v;
        }
      });
      mapped.add(map);
    }
    return mapped;
  }
}
