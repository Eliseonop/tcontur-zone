import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeolocatorApp extends StatefulWidget {
  const GeolocatorApp({Key? key}) : super(key: key);

  @override
  _GeolocatorAppState createState() => _GeolocatorAppState();
}

class _GeolocatorAppState extends State<GeolocatorApp> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  Position? _currentPosition;
  LocationPermission _locationPermission = LocationPermission.values.last;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();

    final service = FlutterBackgroundService();

    final locationPermissionStream =
        _geolocatorPlatform.checkPermission().asStream();
    // .map((status) => status == LocationPermission.always);
    locationPermissionStream.listen((hasLocationPermission) {
      setState(() {
        _locationPermission = hasLocationPermission;
      });

      if (_locationPermission == LocationPermission.denied) {
        // Los permisos de ubicación fueron desactivados
        // Puedes hacer algo aquí, como mostrar una notificación o detener el servicio.

        print('Location permission revoked');
      } else if (_locationPermission == LocationPermission.deniedForever) {
        // Los permisos de ubicación fueron desactivados permanentemente
        // Puedes hacer algo aquí, como mostrar una notificación o detener el servicio.
        print('Location permission permanently revoked');
      } else if (_locationPermission == LocationPermission.whileInUse ||
          _locationPermission == LocationPermission.always) {
        final shared = SharedPreferences.getInstance();
        shared.then((value) {
          if (value.getString('user') != null) {
            service.startService();
            service.invoke('setAsForeground');
          }
        });
        // Los permisos de ubicación fueron activados
        // Puedes hacer algo aquí, como iniciar el servicio o actualizar la ubicación.
        // service.startService();
        // service.invoke("setAsForeground");

        print('Location permission granted');
      }
    });
  }

  void _startLocationUpdates() {
    _geolocatorPlatform.getServiceStatusStream().listen((event) {
      print('Service status changed: $event');

      if (event == ServiceStatus.enabled &&
          _locationPermission == LocationPermission.always) {
        Timer.periodic(const Duration(seconds: 10), (_) {
          if (event == ServiceStatus.enabled &&
              _locationPermission == LocationPermission.always) {
            _getCurrentLocation();
          }
        });
      } else {
        print('Service status changed: $event');
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _geolocatorPlatform.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  Future<void> _requestLocationPermission() async {
    final permission = await _geolocatorPlatform.requestPermission();
    // if (permission == LocationPermission.deniedForever) {
    //   // Los permisos de ubicación fueron denegados permanentemente
    //   // Puedes hacer algo aquí, como mostrar un mensaje de error o redirigir al usuario a la configuración de la aplicación.
    print('Location permission permanently denied $permission');
    // } else {
    setState(() {
      _locationPermission = permission;
    });
  }

  @override
  void dispose() {
    _serviceStatusStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> activateUbicacion() async {
    _geolocatorPlatform.getServiceStatusStream().listen((event) {
      if (event == ServiceStatus.disabled) {
        Geolocator.openLocationSettings();
        print('Servicio desactivado');
      } else if (event == ServiceStatus.enabled) {
        print('Servicio activado');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocator App',
      home: StreamBuilder<ServiceStatus>(
        stream: _geolocatorPlatform.getServiceStatusStream(),
        initialData: ServiceStatus.disabled,
        builder: (context, snapshot) {
          final serviceStatus = snapshot.data;
          final isLocationServiceEnabled =
              serviceStatus == ServiceStatus.enabled;

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLocationServiceEnabled)
                    Column(
                      children: [
                        const Text(
                          'Los servicios de ubicación están desactivados.',
                          textAlign: TextAlign.center,
                        ),
                        ElevatedButton(
                          onPressed: activateUbicacion,
                          child: const Text('Activar Ubicación'),
                        ),
                      ],
                    )
                  else if (_locationPermission ==
                          LocationPermission.deniedForever ||
                      _locationPermission == LocationPermission.denied)
                    Column(
                      children: [
                        const Text(
                          'Los permisos de ubicación están denegados permanentemente.',
                          textAlign: TextAlign.center,
                        ),
                        ElevatedButton(
                          onPressed: _requestLocationPermission,
                          child: const Text('Volver a pedir permisos'),
                        ),
                      ],
                    )
                  else if (_currentPosition != null)
                    Text(
                      'Latitude: ${_currentPosition!.latitude}\n'
                      'Longitude: ${_currentPosition!.longitude}',
                      textAlign: TextAlign.center,
                    )
                  else
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
