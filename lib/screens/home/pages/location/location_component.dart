import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    initializeServiceBackGround();
    checkServiceBackgroundStatus();
    checkPermissionStatus();
    checkServiceLocationStatus();
    requestPermission();
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

      if (serviceStatus == ServiceStatus.disabled) {
        flutterLocalNotificationsPlugin.show(
          999,
          'Ubicación desactivada',
          'Por favor, active el servicio de ubicación.',
          const NotificationDetails(
            android: AndroidNotificationDetails(myChanelId, myChanelName,
                priority: Priority.low, ongoing: false),
          ),
        );
      }
    });
  }

  Future<void> requestPermission() async {
    if (permission == LocationPermission.denied) {
      final permissionStatus = await Geolocator.requestPermission();
      setState(() {
        permission = permissionStatus;
      });
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();

      final permissionStatus = await Geolocator.requestPermission();
      setState(() {
        permission = permissionStatus;
      });
    }
  }

  Future<void> activateLocation() async {
    await Geolocator.openLocationSettings();
    // await checkServiceLocationStatus();
  }

  Future<void> checkServiceBackgroundStatus() async {
    final isRunning = await FlutterBackgroundService().isRunning();
    setState(() {
      _isServiceRunning = isRunning;
    });
  }

  Future<void> _startService() async {
    await FlutterBackgroundService().startService();

    FlutterBackgroundService().invoke('setAsBackground');
    FlutterBackgroundService().invoke('setAsForeground');

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
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          // TextButton(
          //   onPressed: () {
          //     checkPermissionStatus();
          //     checkServiceLocationStatus();
          //   },
          //   child: Text('Comprobar Servicios'),
          // ),
          const SizedBox(height: 20.0),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildPermissionsCard(size),
              _buildServiceStatusLocationCard(size),
            ],
          ),
          const SizedBox(height: 30.0),

          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildServiceStatusCard(size),

              // botones en coluna para
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceStatusCard(Size size) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _isServiceRunning ? _stopService() : _startService();
          },
          child: Container(
            height: size.height * 0.125,
            width: size.width * 0.23,
            decoration: BoxDecoration(
              color:
                  _isServiceRunning ? Colors.greenAccent : Colors.blueGrey[600],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (_isServiceRunning)
                  BoxShadow(
                    color: Colors.greenAccent,
                    blurRadius: 30,
                    offset: Offset(5, 5),
                  ),
                if (!_isServiceRunning)
                  BoxShadow(
                    color: Colors.blueGrey[600]!,
                    blurRadius: 30,
                    offset: Offset(5, 5),
                  ),

                // BoxShadow(
                //   color: Colors.grey.shade100,
                //   blurRadius: 30,
                //   offset: Offset(5, 5),
                // ),
              ],
            ),
            child: Icon(
              _isServiceRunning ? Icons.play_arrow : Icons.pause,
              color: Colors.black,
              size: 45,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.025),
        Text(
          _isServiceRunning ? 'Corriendo' : 'Detenido',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsCard(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Permisos de ubicación',
          style: TextStyle(
            color: Colors.white,
            // fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.025),
        GestureDetector(
          onTap: () {
            requestPermission();
          },
          child: Container(
            height: size.height * 0.125,
            width: size.width * 0.23,
            decoration: BoxDecoration(
              color: permission == LocationPermission.denied
                  ? Colors.orange
                  : permission == LocationPermission.deniedForever
                      ? Colors.red
                      : permission == LocationPermission.whileInUse
                          ? Colors.yellow
                          : permission == LocationPermission.always
                              ? Colors.greenAccent
                              : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (permission == LocationPermission.denied ||
                    permission == LocationPermission.deniedForever)
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 30,
                    offset: Offset(5, 5),
                  ),
                if (permission == LocationPermission.whileInUse ||
                    permission == LocationPermission.always)
                  BoxShadow(
                    color: Colors.greenAccent,
                    blurRadius: 30,
                    offset: Offset(5, 5),
                  ),

                // BoxShadow(
                //   color: Colors.grey.shade100,
                //   blurRadius: 30,
                //   offset: Offset(5, 5),
                // ),
              ],
            ),
            child: Icon(
              permission == LocationPermission.denied ||
                      permission == LocationPermission.deniedForever
                  ? Icons.location_disabled
                  : Icons.location_on,
              color: Colors.black,
              size: 45,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.025),
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
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceStatusLocationCard(Size size) {
    return Column(
      children: [
        Text(
          'Servicio de ubicación',
          style: TextStyle(
            color: Colors.white,
            // fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.025),
        GestureDetector(
          onTap: () {
            // requestPermission();
            activateLocation();
          },
          child: Container(
            height: size.height * 0.125,
            width: size.width * 0.23,
            decoration: BoxDecoration(
              color: serviceStatus == ServiceStatus.disabled
                  ? Colors.red
                  : serviceStatus == ServiceStatus.enabled
                      ? Colors.greenAccent
                      : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (serviceStatus == ServiceStatus.disabled)
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 30,
                    offset: Offset(5, 5),
                  ),
                if (serviceStatus == ServiceStatus.enabled)
                  BoxShadow(
                    color: Colors.greenAccent,
                    blurRadius: 30,
                    offset: Offset(5, 5),
                  ),
                // BoxShadow(
                //   color: Colors.grey.shade100,
                //   blurRadius: 30,
                //   offset: Offset(5, 5),
                // ),
              ],
            ),
            child: Icon(
              Icons.map,
              color: Colors.black,
              size: 45,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.025),
        Text(
          serviceStatus == ServiceStatus.disabled
              ? 'Desactivado'
              : serviceStatus == ServiceStatus.enabled
                  ? 'Activado'
                  : 'Desconocido',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildButton(BuildContext context, IconData icon, String text,
      String title, Size size) {
    return Column(
      children: [],
    );
  }
}
