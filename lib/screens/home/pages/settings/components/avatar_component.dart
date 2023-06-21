import 'package:flutter/material.dart';
import 'package:tcontur_zone/auth/models/user_model.dart';

class AvatarComponent extends StatelessWidget {
  final User user;

  const AvatarComponent({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenido ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                user.firstName,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            // backgroundColor:
            radius: 50,
            child: Text(
              user.firstName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${user.firstName} ${user.email}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
