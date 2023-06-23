import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcontur_zone/auth/models/user_model.dart';
import 'package:tcontur_zone/screens/home/pages/settings/components/avatar_component.dart';
import 'package:tcontur_zone/screens/welcome/welcome_screen.dart';

class MySettingPage extends StatefulWidget {
  const MySettingPage({super.key});

  @override
  State<MySettingPage> createState() => _MySettingPageState();
}

class _MySettingPageState extends State<MySettingPage> {
  Future<User?> getUserFromSharedPreferences() async {
    // await EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final user = User.fromJson(userMap);
      return user;
    } else {
      return null;
    }
    // await EasyLoading.dismiss();
  }

  Future<void> logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0x990066a9),
      child: FutureBuilder<User?>(
        future: getUserFromSharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error al cargar los datos');
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Scaffold(
              backgroundColor: const Color(0x990066a9),
              body: Column(
                children: [
                  const SizedBox(height: 40),
                  AvatarComponent(user: data),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    child: TextButton(
                      onPressed: () {
                        logout(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[300]),
                        alignment: Alignment.center,
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 20),
                        ),
                      ),
                      child: const Text("Logout",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text('No hay datos');
          }
        },
      ),
    );
  }
}
