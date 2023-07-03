import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tcontur_zone/screens/home/pages/location/test_location.dart';
import 'package:tcontur_zone/screens/home/pages/settings/settings_page.dart';
import 'package:tcontur_zone/services/background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // int _currentIndex = 0;
  // bool _locationActive = false;
  // final List<Widget> _screens = [
  //   const GeolocatorApp(),
  //   const MySettingPage(),
  // ];
  @override
  void initState() {
    super.initState();

    // Permission.location.serviceStatus.asStream().listen((event) {
    //   print('event: $event');
    // });
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    final permissionStatus = await Permission.locationWhenInUse.status;

    if (permissionStatus.isDenied) {
      // No se han otorgado permisos de ubicación
      await requestLocationPermission();
    } else {
      // Se han otorgado permisos de ubicación
      await initializeServiceBackGround();

      // Puedes realizar las operaciones necesarias aquí
    }
  }

  Future<void> requestLocationPermission() async {
    final permissionStatus = await Permission.locationWhenInUse.request();
    if (permissionStatus.isDenied) {
      // El usuario ha denegado el permiso de ubicación
      showLocationPermissionDeniedNotification();
    } else {
      // El usuario ha otorgado el permiso de ubicación
      initializeServiceBackGround();
      // Puedes realizar las operaciones necesarias aquí
    }
  }

  void showLocationPermissionDeniedNotification() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails channelSpecifics =
        AndroidNotificationDetails(
      'location_permission_channel',
      'Location Permission',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: channelSpecifics);
    flutterLocalNotificationsPlugin.show(
      0,
      'Permiso de ubicación denegado',
      'Esta app necesita permisos de ubicación para funcionar correctamente.',
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Evitar que se pueda regresar al presionar el botón de retroceso
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tcontur Zone'),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: MySettingPage(),
        ),
        body: GeolocatorApp(),
      ),
    );
  }
}
