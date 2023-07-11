import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcontur_zone/auth/models/user_response.dart';
import 'package:tcontur_zone/services/service_location.dart';

Future<void> initializeServiceBackGround() async {
  final service = FlutterBackgroundService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
    playSound: false,
    enableVibration: false,
  );

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('icon'),
    ),
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
      androidConfiguration: AndroidConfiguration(
          // this will be executed when app is in foreground or background in separated isolate
          onStart: onStart,
          // auto start servic
          autoStart: false,
          isForegroundMode: true,
          notificationChannelId: 'my_foreground',
          initialNotificationTitle: 'Serivicio de zona activo',
          initialNotificationContent: 'Iniciando Servicio...',
          foregroundServiceNotificationId: 888,
          autoStartOnBoot: false),
      iosConfiguration: IosConfiguration());

  // service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      print('EVENT 44 BACKGRUND SERVICE $event');
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  bool isCounterRunning = false;
  int counter = 0;
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.getActiveNotifications()
      .asStream()
      .listen((event) {
    print('EVENT 145 BACKGRUND SERVICE $event');
  });

  service.on('stopService').listen((event) async {
    flutterLocalNotificationsPlugin.cancelAll();
    await flutterLocalNotificationsPlugin.show(
      888,
      'Servicio finalizado',
      '¡gracias por confiar en nosotros!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'my_foreground', 'MY FOREGROUND SERVICE',
            ongoing: false),
      ),
    );

    service.stopSelf();
  });
  Geolocator.checkPermission().asStream().listen((hasLocationPermission) {
    print('hasLocationPermission 25: $hasLocationPermission');
  });
  Geolocator.getServiceStatusStream().listen((event) {
    print('event 28: $event');
  });

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (!isCounterRunning) {
      isCounterRunning = true;
    }

    counter++;

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          888,
          'SERVICE ZONE EJECUTÁNDOSE',
          'Counter: $counter',
          const NotificationDetails(
            android: AndroidNotificationDetails(
                'my_foreground', 'MY FOREGROUND SERVICE',
                ongoing: true),
          ),
        );

        // Check the location permission status and the location services status.
        LocationPermission permission = await Geolocator.checkPermission();

        /// The line `bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();` is
        /// checking whether the location services are enabled on the device.

        bool isLocationServiceEnabled =
            await Geolocator.isLocationServiceEnabled();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever ||
            !isLocationServiceEnabled) {
          // Show a notification if the location permission has been revoked or the location services are disabled.
          if (!isLocationServiceEnabled) {
            flutterLocalNotificationsPlugin.show(
              999,
              'Ubicación desactivada',
              'Por favor, active el servicio de ubicación.',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                    'my_foreground', 'MY FOREGROUND SERVICE',
                    ongoing: true),
              ),
            );
            if (permission == LocationPermission.denied ||
                permission == LocationPermission.deniedForever) {
              flutterLocalNotificationsPlugin.show(
                9993,
                'Permiso de ubicación denegado',
                'Por favor, otorgue los permisos necesarios.',
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                      progress: 100,
                      'my_foreground',
                      'MY FOREGROUND SERVICE',
                      ongoing: true),
                ),
              );
            }
          }
        } else {
          // Get the current position and show it in a notification.
          final prefs = await SharedPreferences.getInstance();
          final userJson = prefs.getString('user');
          if (userJson != null) {
            final user = UserRes.fromJson(json.decode(userJson));
            print('user 117: $user');
            try {
              Position position = await _geolocatorPlatform.getCurrentPosition(
                  locationSettings:
                      AndroidSettings(accuracy: LocationAccuracy.best));

              print('position 117: $position');

              DateTime now = DateTime.now();
              String formattedDate =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
              LocationServiceUrbanito locationServiceUrbanito =
                  LocationServiceUrbanito();
              await locationServiceUrbanito.sendLocationData(
                position.latitude,
                position.longitude,
                formattedDate,
              );
            } catch (e) {
              print('error 204: $e');
            }
          } else {
            // print('user 119: null');
            // ir a login
            FlutterBackgroundService().invoke('stopService');
          }
          try {
            Position position = await _geolocatorPlatform.getCurrentPosition(
                locationSettings:
                    AndroidSettings(accuracy: LocationAccuracy.best));

            print('position 117: $position');
            flutterLocalNotificationsPlugin.show(
              999,
              'Ubicación actual',
              'Latitud: ${position.latitude}, Longitud: ${position.longitude}',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                    'my_foreground', 'MY FOREGROUND SERVICE',
                    ongoing: true),
              ),
            );
            // DateTime now = DateTime.now();
            // String formattedDate =
            //     DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
            // await LocationServiceUrbanito().sendLocationData(
            //   position.latitude,
            //   position.longitude,
            //   formattedDate,
            // );
          } catch (e) {
            bool isLocationServiceEnabled =
                await Geolocator.isLocationServiceEnabled();
            if (isLocationServiceEnabled) {
              flutterLocalNotificationsPlugin.show(
                999,
                'Ubicación desactivada',
                'Por favor, active ubicación de alta precisión.',
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                      'my_foreground', 'MY FOREGROUND SERVICE',
                      ongoing: true),
                ),
              );
            }

            print('isLocationServiceEnabled 128: $isLocationServiceEnabled');
            print(e);
            print('e 119: $e');
          }
        }
      }
    }
  });
}
