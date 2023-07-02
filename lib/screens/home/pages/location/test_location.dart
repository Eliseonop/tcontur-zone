import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class GeolocatorApp extends StatefulWidget {
  const GeolocatorApp({Key? key}) : super(key: key);

  @override
  _GeolocatorAppState createState() => _GeolocatorAppState();
}

class _GeolocatorAppState extends State<GeolocatorApp> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    Timer.periodic(const Duration(seconds: 10), (_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _geolocatorPlatform.getCurrentPosition(
          locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ));
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  @override
  void dispose() {
    _serviceStatusStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocator App',
      home: StreamBuilder<ServiceStatus>(
        stream: _geolocatorPlatform.getServiceStatusStream(),
        initialData: ServiceStatus.values.first,
        builder: (context, snapshot) {
          final serviceStatus = snapshot.data;
          final isLocationServiceEnabled =
              serviceStatus == ServiceStatus.enabled;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Geolocator App'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLocationServiceEnabled)
                    const Text(
                      'Los servicios de ubicación están desactivados.',
                      textAlign: TextAlign.center,
                    )
                  else if (_currentPosition != null)
                    Text(
                      'Latitude: ${_currentPosition!.latitude}\n'
                      'Longitude: ${_currentPosition!.longitude}',
                      textAlign: TextAlign.center,
                    )
                  else
                    const Text(
                      'Obteniendo ubicación...',
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
