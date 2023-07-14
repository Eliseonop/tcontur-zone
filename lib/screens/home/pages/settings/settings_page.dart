import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcontur_zone/auth/models/user_response.dart';
import 'package:tcontur_zone/screens/home/pages/location/test_location.dart';
import 'package:tcontur_zone/screens/home/pages/settings/components/avatar_component.dart';
import 'package:tcontur_zone/screens/login/login_screen.dart';

class MySettingPage extends StatefulWidget {
  const MySettingPage({Key? key}) : super(key: key);

  @override
  State<MySettingPage> createState() => _MySettingPageState();
}

class _MySettingPageState extends State<MySettingPage> {
  Future<UserRes?> getUserFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final user = UserRes.fromJson(userMap);
      return user;
    } else {
      return null;
    }
  }

  Future<void> logout(context) async {
    FlutterBackgroundService().invoke('stopService');

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Future<void> goComprobate(context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GeolocatorApp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff5f6d8e),
            Color(0xff4b5a75),
            Color(0xff374a66),
            Color(0xff263449),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
      width: double.infinity,
      child: FutureBuilder<UserRes?>(
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
              body: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 40),
                      AvatarComponent(user: data),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 200,
                        child: TextButton(
                          onPressed: () {
                            goComprobate(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[300]),
                            alignment: Alignment.center,
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 20),
                            ),
                          ),
                          child: const Text("Comprobar Estado",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          logout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
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
