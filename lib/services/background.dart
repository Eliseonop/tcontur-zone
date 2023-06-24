import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeService();
//   runApp(const MyApp());
// }

Future<void> initializeServiceBackGround() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    playSound: true,
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_stat_logoandroid')),
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service

      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Serivicio de zona activo',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  //if(!await service.isRunning()) {
  //service.startService();
  //};
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.reload();
  // final log = preferences.getStringList('log') ?? <String>[];
  // log.add(DateTime.now().toIso8601String());
  // await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
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
  Timer? counterTimer;

  service.on('update').listen((event) {
    final counterValue = event?['counter'] as int?;
    if (counterValue != null) {
      counter = counterValue;
      print('Counter updated: $counter');
    }
  });

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    // service.setForegroundNotificationInfo(
    //   title: "My App Service",
    //   content: "Counter: $counter",
    // );

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  Timer.periodic(const Duration(seconds: 3), (timer) async {
    if (!isCounterRunning) {
      isCounterRunning = true;
      counterTimer = timer;
    }

    counter++;

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        // Actualizar la notificación con el contador
        print('yes foreground service');
        flutterLocalNotificationsPlugin.show(
          888,
          'SERVICE ZONE EJECCUTANDOSE',
          'Counter: $counter',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'icon',
              ongoing: true,
            ),
          ),
        );

        //final imageUrl = 'assets/images/icon.png';
        // showNotificationWithImage();
        // service.setForegroundNotificationInfo(
        //   title: "My App Service",
        //   content:
        //       "El servicio esta siendo ejecutado en primer plano: $counter",
        // );

        // if you don't using custom notification, uncomment this
      }
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: $counter');

    service.invoke(
      'update',
      {
        "counter": counter,
      },
    );
  });
}

// Future<void> showNotificationWithImage() async {
//   final String imageUrl = 'assets/images/icon.png';

//   final AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'channel_id',
//     'Channel Name',
//     importance: Importance.high,
//     styleInformation: BigTextStyleInformation(
//       'Mensaje de la notificación',
//       htmlFormatContent: true,
//       htmlFormatTitle: true,
//       summaryText: 'Resumen de la notificación',
//     ),
//   );

//   final NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);

//   await FlutterLocalNotificationsPlugin().show(
//     0,
//     'Notificación con imagen',
//     'Contenido de la notificación',
//     platformChannelSpecifics,
//   );
// }
