import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

class ApiClient {
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8085';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:8085';
    return 'http://127.0.0.1:8085';
  }
  
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('username');
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Usuario';
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer \$token',
    };
  }

  static Future<dynamic> login(String login, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'login': login, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await setToken(data['token']);
      // Guardar el nombre de usuario para mostrarlo en el home
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', login);
      return data;
    } else {
      throw Exception('Failed to login (Status ' + response.statusCode.toString() + '): ' + response.body);
    }
  }

  static Future<dynamic> register(String login, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'login': login, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to register (Status ' + response.statusCode.toString() + '): ' + response.body);
    }
  }

  static Future<List<dynamic>> getContracts() async => _get('/api/contract');
  static Future<List<dynamic>> getAttendance() async => _get('/api/attendance');
  static Future<List<dynamic>> getJourney() async => _get('/api/journey');
  static Future<List<dynamic>> getPermissions() async => _get('/api/permission');
  static Future<List<dynamic>> getSchedule() async => _get('/api/schedule');
  static Future<List<dynamic>> getShift() async => _get('/api/shift');
  static Future<List<dynamic>> getSupport() async => _get('/api/support');

  static Future<List<dynamic>> _get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load ' + endpoint + ': ' + response.body);
    }
  }
}
