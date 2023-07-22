import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tcontur_zone/auth/models/user_response.dart';

class UserProvider extends ChangeNotifier {
  String? urlApi = dotenv.env['API_URL_GENERAL'];

  UserRes? _user;

  UserRes? get user => _user;

  void setUser(UserRes user) {
    _user = user;
    notifyListeners();
  }

  Future<void> login(String username, String password, String empresa) async {
    String url = 'https://$empresa${urlApi!}/api/token-auth';

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

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      final userJson = json.decode(userData);
      _user = UserRes.fromJson(userJson);
    }

    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    notifyListeners();
  }
}
