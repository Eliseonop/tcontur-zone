import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tcontur_zone/screens/home/pages/location/components/background_component.dart';
import 'package:tcontur_zone/services/notification.dart';

class MyLocationPage extends StatefulWidget {
  const MyLocationPage({Key? key}) : super(key: key);

  @override
  State<MyLocationPage> createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  bool serviceEnabled = false;
  late Position? position;

  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  Future<void> determinePosition() async {

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // El usuario rechazó los permisos de ubicación
          return;
        }
      }

      final newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );



      if (kDebugMode) {
        print(newPosition);
      }

      setState(() {
        position = newPosition;
        serviceEnabled = true;
      });

      showNotification(
        'Ubicación actualizada',
        'Latitud: ${position!.latitude}, Longitud: ${position!.longitude}',
        'location'
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener la ubicación: $e');
      }
      // Manejar el error de obtener la ubicación
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ServiceControlWidget(),
            ],

        ),
      ),
    );
  }
}
