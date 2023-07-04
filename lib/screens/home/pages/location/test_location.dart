import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tcontur_zone/services/background.dart';

class GeolocatorApp extends StatefulWidget {
  const GeolocatorApp({Key? key}) : super(key: key);

  @override
  GeolocatorAppState createState() => GeolocatorAppState();
}

class GeolocatorAppState extends State<GeolocatorApp> {
  bool _isServiceRunning = false;
  LocationPermission permision = LocationPermission.denied;
  ServiceStatus serviceStatus = ServiceStatus.disabled;

  @override
  void initState() {
    super.initState();
    initializeServiceBackGround();
    _checkServiceStatus();

    Geolocator.checkPermission().asStream().listen((value) {
      print('permision =>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: $value');
      setState(() {
        permision = value;
      });
    });

    Geolocator.getServiceStatusStream().listen((event) {
      print('serviceStatus =>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: $event');
      setState(() {
        serviceStatus = event;
      });
    });
  }

  Future<void> _checkServiceStatus() async {
    final isRunning = await FlutterBackgroundService().isRunning();
    setState(() {
      _isServiceRunning = isRunning;
    });
  }

  Future<void> _startService() async {
    await FlutterBackgroundService().startService();
    setState(() {
      _isServiceRunning = true;
    });
  }

  Future<void> _stopService() async {
    FlutterBackgroundService().invoke('stopService');
    setState(() {
      _isServiceRunning = false;
    });
  }

  Future<void> activateUbication() async {
    final referend = Geolocator.openLocationSettings();

    referend.then((value) {
      setState(() {});
    });
  }

  Future<void> requestPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission().then((value) async {
        final permission = await Geolocator.checkPermission();
        setState(() {
          permision = permission;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocator App',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<ServiceStatus>(
                stream: Geolocator.getServiceStatusStream(),
                initialData: serviceStatus,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data == ServiceStatus.disabled) {
                    return ElevatedButton(
                      onPressed: () async {
                        await activateUbication();
                      },
                      child: Text('Activar Ubicación Precisa'),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              StreamBuilder<LocationPermission>(
                stream: Geolocator.checkPermission().asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      (snapshot.data == LocationPermission.denied ||
                          snapshot.data == LocationPermission.deniedForever)) {
                    return ElevatedButton(
                      onPressed: () async {
                        await requestPermission();
                      },
                      child: Text('Activar Permisos'),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              if (_isServiceRunning)
                TextButton(
                  onPressed: _stopService,
                  child: Text('Desactivar servicio'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Color(0xffffffff),
                  ),
                ),
              if (!_isServiceRunning)
                TextButton(
                  onPressed: _startService,
                  child: Text('Activar servicio'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Color(0xffffffff),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
