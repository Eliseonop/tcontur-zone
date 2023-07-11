import 'package:flutter/material.dart';
import 'package:tcontur_zone/auth/models/user_response.dart';

class AvatarComponent extends StatelessWidget {
  final UserRes user;
  const AvatarComponent({Key? key, required this.user}) : super(key: key);

  String? get nombre => user.nombre?.substring(0, 1) ?? '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenido ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // Text(
              //   user.nombre ?? '',
              //   style: const TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //       color: Color.fromARGB(255, 219, 214, 231)),
              // ),
            ],
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  nombre ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Cargo: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: user.cargo ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Correo: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: user.email ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
