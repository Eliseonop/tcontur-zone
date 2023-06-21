import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcontur_zone/auth/models/auth_response.dart';
import 'package:tcontur_zone/auth/models/user_model.dart';


class AuthService {
  String _token = '';
  User? _user;

  User? get user => _user;

  Future<void> login(String username, String password) async {
    const url = 'https://backend-planilla-23lnu3rcea-uc.a.run.app/login';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final authResponse = AuthResponse.fromJson(jsonResponse);

      // Guardar información en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', authResponse.token);
      await prefs.setString('user', json.encode(authResponse.user));

      // Actualizar las variables locales
      _token = authResponse.token;
      _user = authResponse.user;
    } else {
      throw Exception('Error en la autenticación');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    _token = '';
    _user = null;
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('user');

    if (token != null && userJson != null) {
      _token = token;
      _user = User.fromJson(json.decode(userJson));
    }
  }

  bool isAuthenticated() {
    return _token.isNotEmpty;
  }
}
