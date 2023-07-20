import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcontur_zone/auth/models/empresas_response.dart';
import 'package:tcontur_zone/auth/models/user_response.dart';
// import 'package:http/http.dart' as http;
// import 'package:tcontur_zone/provider/provider_empresa.dart';
// import 'package:tcontur_zone/services/notification.dart';
import 'package:tcontur_zone/services/service_location.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const String myChanelId = 'channel_id';
const String myChanelName = 'channel_name';

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('drawable/icon');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      print('notification payload: $payload');
    }
  }

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    myChanelId,
    myChanelName,
    importance: Importance.high,
    enableVibration: false,
    playSound: false,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  // await flutterLocalNotificationsPlugin
}

Future<void> initializeServiceBackGround() async {
  final service =
      FlutterBackgroundService(); // Default is ic_launcher from folder mipmap
  await initNotifications();

  await service.configure(
      androidConfiguration: AndroidConfiguration(
          // this will be executed when app is in foreground or background in separated isolate
          onStart: onStart,
          // auto start servic
          autoStart: false,
          isForegroundMode: false, // default is false
          notificationChannelId: myChanelId,
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

  // final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

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

  service.on('stopService').listen((event) async {
    flutterLocalNotificationsPlugin.cancelAll();
    await flutterLocalNotificationsPlugin.show(
      8882,
      'Servicio finalizado',
      '¡Gracias por confiar en nosotros!',
      const NotificationDetails(
        android: AndroidNotificationDetails(myChanelId, 'MY FOREGROUND SERVICE',
            priority: Priority.max, playSound: true, ongoing: false),
      ),
    );

    service.stopSelf();
  });
  // Geolocator.checkPermission().asStream().listen((hasLocationPermission) {
  //   print('hasLocationPermission 25: $hasLocationPermission');
  // });
  // Geolocator.getServiceStatusStream().listen((event) {
  //   print('event 28: $event');
  // });

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (!isCounterRunning) {
      isCounterRunning = true;
    }
    print('counter: $counter');
    counter++;

    if (service is AndroidServiceInstance) {
      //   // if (await service.isForegroundService()) {
      //   flutterLocalNotificationsPlugin.show(
      //     8882,
      //     'SERVICE ZONE EJECUTÁNDOSE',
      //     'Counter: $counter',
      //     payload: 'este es mi contador zdddzdz: $counter',
      //     const NotificationDetails(
      //       android: AndroidNotificationDetails(myChanelId, myChanelName,
      //           priority: Priority.low,
      //           playSound: false,
      //           enableVibration: false,
      //           ongoing: true),
      //     ),
      // );

      service.setForegroundNotificationInfo(
        title: "My App Service",
        content: "Updated at ${DateTime.now()}",
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
            9994,
            'Ubicación desactivada',
            'Por favor, active el servicio de ubicación.',
            const NotificationDetails(
              android: AndroidNotificationDetails(myChanelId, myChanelName,
                  priority: Priority.low, ongoing: true),
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
                    priority: Priority.low,
                    progress: 100,
                    myChanelId,
                    myChanelName,
                    playSound: false,
                    ongoing: true),
              ),
            );
          }
        }
      } else {
        // Get the current position and show it in a notification.
        print('estamos cerca de donde se envía la ubicación');

        final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
//       //  LocationServiceUrbanito().sendLocationData(latitude, longitude, timestamp)

        final timeStamp = getFormattedTimestamp();

        final prefs = await SharedPreferences.getInstance();
        final empresa = prefs.getString('selectedEmpresa');

        print('empresa 202: $empresa');
        final userJson = prefs.getString('user');
        print('userJson 204: $userJson');
        if (userJson != null && empresa != null) {
          final user = UserRes.fromJson(json.decode(userJson));
          final empresaFinal = EmpresaResponse.fromJson(json.decode(empresa));
          final token = user.token;

          print(
              '202 backgorund empresa:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $empresa');
          print('token: $token');
          print('position: $position');
          print('timeStamp: $timeStamp');
          await dotenv.load();
          if (dotenv.env.containsKey('API_URL_GENERAL')) {
            final apiUrl = dotenv.env['API_URL_GENERAL'];

            final String urlFinal =
                'https://${empresaFinal.nombre}$apiUrl/api/inspecciones/update_position';
            print('urlFinal: $urlFinal');
            final response = await LocationServiceUrbanito().sendLocationData(
                position.latitude,
                position.longitude,
                timeStamp,
                token,
                urlFinal);

            final respuesta = json.decode(response.body);
            if (response.statusCode == 200) {
              flutterLocalNotificationsPlugin.show(
                9994,
                'Ubicación enviada',
                'Ubicación enviada $respuesta.',
                payload: ' payload ok ddd $respuesta',
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                      priority: Priority.low,
                      progress: 100,
                      myChanelId,
                      myChanelName,
                      playSound: false,
                      ongoing: true),
                ),
              );
            } else {
              print('Error al enviar ubicación $respuesta');
              flutterLocalNotificationsPlugin.show(
                9994,
                'Error al enviar ubicación',
                'Error al enviar ubicación.',
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                      priority: Priority.low,
                      progress: 100,
                      myChanelId,
                      myChanelName,
                      playSound: false,
                      ongoing: true),
                ),
              );
            }
          } else {
            print(
                'No se encontró la variable API_URL_URBANITO en el archivo .env.');
          }
        } else {
          // print('user 119: null');
          // ir a login
          FlutterBackgroundService().invoke('stopService');
        }

        bool isLocationServiceEnabled =
            await Geolocator.isLocationServiceEnabled();
        if (!isLocationServiceEnabled) {
          flutterLocalNotificationsPlugin.show(
            999,
            'Ubicación desactivada',
            'Por favor, active ubicación de alta precisión.',
            const NotificationDetails(
              android: AndroidNotificationDetails(myChanelId, myChanelName,
                  ongoing: true),
            ),
          );
        }

        print('isLocationServiceEnabled 128: $isLocationServiceEnabled');
        print(e);
        print('e 119: $e');
      }
    }
    // }
  });
}

String getFormattedTimestamp() {
  final now = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(now);
}
