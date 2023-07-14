import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationServiceUrbanito {
  Future<http.Response> sendLocationData(double latitude, double longitude,
      String timestamp, String token, String apiUrl) async {
    print('Enviando ubicación a Urbanito $apiUrl');
    late final http.Response response;

    final headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    };

    final data = {
      'lat': latitude,
      'lon': longitude,
      'ts': timestamp,
    };

    response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(data),
    );

    return response;
  }
}
