import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcontur_zone/auth/models/user_response.dart';

class LocationServiceUrbanito {
  final String? apiUrl = dotenv.env['API_URL_URBANITO'];

  Future<void> sendLocationData(
      double latitude, double longitude, String timestamp) async {
    print('Enviando ubicación a Urbanito $apiUrl');

    try {
      // final prefs = await SharedPreferences.getInstance();
      // final userJson = prefs.getString('user');
      // if (userJson != null) {
      //   final user = UserRes.fromJson(json.decode(userJson));
      //   final token = user.token;

      //   final headers = {
      //     'Authorization': 'token $token',
      //     'Content-Type': 'application/json',
      //   };

      //   final data = {
      //     'lat': latitude,
      //     'lon': longitude,
      //     'ts': timestamp,
      //   };

      //   final response = await http.post(
      //     Uri.parse(apiUrl!),
      //     headers: headers,
      //     body: json.encode(data),
      //   );

      //   if (response.statusCode == 200) {
      //     // La petición se realizó correctamente
      //     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      //         FlutterLocalNotificationsPlugin();
      //     flutterLocalNotificationsPlugin.show(
      //       999,
      //       'Ubicación enviada',
      //       'Inf: $response.body, timestamp: $timestamp',
      //       const NotificationDetails(
      //         android: AndroidNotificationDetails(
      //             'my_foreground', 'MY FOREGROUND SERVICE',
      //             ongoing: true),
      //       ),
      //     );
      //     print(response.body);
      //     print('Ubicación enviada correctamente');
      //   } else {
      //     // Error en la petición
      //     print('Error al enviar la ubicación');
      //   }
      // } else {
      //   // No se encontró el usuario en SharedPreferences
      //   print('No se encontró el usuario en SharedPreferences');
      // }
    } catch (e) {
      print('Error al enviar la ubicación');
      print(e);
    }
  }
}
