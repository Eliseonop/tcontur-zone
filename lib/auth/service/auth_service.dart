import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tcontur_zone/auth/models/user_response.dart';

class AuthService {
  String? urlApi = dotenv.env['API_URL_URBANITO'];
  UserRes? _user;

  UserRes? get user => _user;

  Future<void> login(String username, String password) async {
    String url = '${urlApi!}/api/token-auth';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final jsonResponse = json.decode(response.body);

      _user = UserRes.fromJson(jsonResponse);

      // Guardar información en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(_user?.toJson()));
    } else {
      print('Error 34 auth_service.dart');
      print(response.body);
      throw Exception('Error en la autenticación');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    _user = null;
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      _user = UserRes.fromJson(json.decode(userJson));
    }
  }

  bool isAuthenticated() {
    return _user != null;
  }
}
