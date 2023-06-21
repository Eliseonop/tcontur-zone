import 'package:flutter/material.dart';
import 'package:tcontur_zone/auth/service/auth_service.dart';
import 'package:tcontur_zone/screens/login/login_screen.dart';


class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Welcome to Track Service"),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200, // Ancho deseado del botón
              child: TextButton(
                onPressed: () {
                  // Navegar a la pantalla de login
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue[300]),
                  alignment: Alignment.center,
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
                child:
                    const Text("Login", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
