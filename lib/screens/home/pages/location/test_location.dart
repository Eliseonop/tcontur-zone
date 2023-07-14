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
  LocationPermission permission = LocationPermission.denied;
  late ServiceStatus serviceStatus = ServiceStatus.disabled;

  @override
  void initState() {
    super.initState();
    // initializeServiceBackGround();
    checkServiceBackgroundStatus();
    checkPermissionStatus();
    checkServiceLocationStatus();

    Geolocator.getServiceStatusStream().listen((event) {
      setState(() {
        serviceStatus = event;
      });
    });

    FlutterBackgroundService().isRunning().asStream().listen((event) {
      print('event =>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' +
          event.toString());
    });
  }

  Future<void> checkPermissionStatus() async {
    final permissionStatus = await Geolocator.checkPermission();
    setState(() {
      permission = permissionStatus;
    });
  }

  Future<void> checkServiceLocationStatus() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      serviceStatus =
          isServiceEnabled ? ServiceStatus.enabled : ServiceStatus.disabled;
    });
  }

  Future<void> requestPermission() async {
    final permissionStatus = await Geolocator.requestPermission();
    setState(() {
      permission = permissionStatus;
    });
  }

  Future<void> activateLocation() async {
    await Geolocator.openLocationSettings();
    await checkServiceLocationStatus();
  }

  Future<void> checkServiceBackgroundStatus() async {
    final isRunning = await FlutterBackgroundService().isRunning();
    setState(() {
      _isServiceRunning = isRunning;
    });
  }

  Future<void> _startService() async {
    await FlutterBackgroundService().startService();

    // FlutterBackgroundService().invoke('setAsBackground');
    // FlutterBackgroundService().invoke('setAsForeground');

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              checkPermissionStatus();
              checkServiceLocationStatus();
            },
            child: Text('Comprobar estado'),
          ),
          _buildPermissionsCard(),
          SizedBox(height: 20.0),
          _buildServiceStatusCard(),
          SizedBox(height: 20.0),
          if (_isServiceRunning)
            // _buildActionButton(
            //   onPressed: _stopService,
            //   label: 'Desactivar servicio',

            // ),
            TextButton(
              onPressed: _stopService,
              child: const Icon(Icons.pause),
              style: TextButton.styleFrom(
                  // backgroundColor: Colors.yellow,
                  foregroundColor: Color(0xffffffff),
                  iconColor: Colors.yellow),
            ),
          if (!_isServiceRunning)
            // _buildActionButton(
            //   onPressed: _startService,
            //   label: 'Activar servicio',
            // ),
            TextButton(
              onPressed: _startService,
              child: const Icon(Icons.play_arrow),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                iconColor: Color(0xffffffff),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPermissionsCard() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.indigoAccent,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Estado de los permisos:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              permission == LocationPermission.denied
                  ? 'Denegado'
                  : permission == LocationPermission.deniedForever
                      ? 'Denegado para siempre'
                      : permission == LocationPermission.whileInUse
                          ? 'Mientras se usa la aplicación'
                          : permission == LocationPermission.always
                              ? 'Siempre'
                              : 'Desconocido',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            if (permission == LocationPermission.denied ||
                permission == LocationPermission.deniedForever)
              TextButton(
                onPressed: requestPermission,
                child: Text('Activar Permisos'),
                style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.cyan),
                  foregroundColor: MaterialStateProperty.all(
                    Color(0xffffffff),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceStatusCard() {
    return Card(
      elevation: 2.0,
      color: Colors.indigoAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Text(
              'Estado del servicio de ubicacion:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                serviceStatus == ServiceStatus.disabled
                    ? 'Desactivado'
                    : serviceStatus == ServiceStatus.enabled
                        ? 'Activado'
                        : 'Desconocido',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            if (serviceStatus == ServiceStatus.disabled)
              ElevatedButton(
                onPressed: activateLocation,
                child: Text('Activar Ubicación Precisa'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Color(0xffffffff),
      ),
    );
  }
}
