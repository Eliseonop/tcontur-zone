// // The callback function should always be a top-level function.
// import 'dart:convert';
// import 'dart:isolate';
// import 'dart:math';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tcontur_zone/auth/models/user_response.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// const String myChanelId = 'channel_id';
// const String myChanelName = 'channel_name';

// Future<void> initNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('drawable/icon');

//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//   void onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (notificationResponse.payload != null) {
//       print('notification payload: $payload');
//     }
//   }

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     myChanelId,
//     myChanelName,
//     importance: Importance.low,
//     enableVibration: false,
//     playSound: false,
//   );

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   // await flutterLocalNotificationsPlugin
// }

// @pragma('vm:entry-point')
// void startCallbackFore() {
//   // The setTaskHandler function must be called to handle the task in the background.
//   FlutterForegroundTask.setTaskHandler(MyTaskHandler());
// }

// class MyTaskHandler extends TaskHandler {
//   SendPort? _sendPort;
//   int _eventCount = 0;

//   // Called when the task is started.
//   @override
//   Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
//     _sendPort = sendPort;

//     // You can use the getData function to get the stored data.
//     final customData =
//         await FlutterForegroundTask.getData<String>(key: 'customData');
//     print('customData: $customData');
//   }

//   // Called every [interval] milliseconds in [ForegroundTaskOptions].
//   @override
//   Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
//     FlutterForegroundTask.updateService(
//       notificationTitle: 'MyTaskHandler',
//       notificationText: 'eventCount: $_eventCount',
//     );

//     LocationPermission permission = await Geolocator.checkPermission();

//     /// The line `bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();` is
//     /// checking whether the location services are enabled on the device.

//     bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever ||
//         !isLocationServiceEnabled) {
//       // Show a notification if the location permission has been revoked or the location services are disabled.
//       if (!isLocationServiceEnabled) {
//         flutterLocalNotificationsPlugin.show(
//           999,
//           'Ubicación desactivada',
//           'Por favor, active el servicio de ubicación.',
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'my_foreground', 'MY FOREGROUND SERVICE',
//                 ongoing: true),
//           ),
//         );
//         if (permission == LocationPermission.denied ||
//             permission == LocationPermission.deniedForever) {
//           flutterLocalNotificationsPlugin.show(
//             9993,
//             'Permiso de ubicación denegado',
//             'Por favor, otorgue los permisos necesarios.',
//             const NotificationDetails(
//               android: AndroidNotificationDetails(
//                   progress: 100,
//                   'my_foreground',
//                   'MY FOREGROUND SERVICE',
//                   ongoing: true),
//             ),
//           );
//         }
//       }
//     } else {
//       // If the location permission has been granted, start the location service.
//       final Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       //  LocationServiceUrbanito().sendLocationData(latitude, longitude, timestamp)

//       final timeStamp = getFormattedTimestamp();

//       final prefs = await SharedPreferences.getInstance();
//       final userJson = prefs.getString('user');
//       if (userJson != null) {
//         final user = UserRes.fromJson(json.decode(userJson));
//         final token = user.token;

//         print('token: $token');
//         print('position: $position');
//         print('timeStamp: $timeStamp');
//         // await dotenv.load();
//         if (dotenv.env.containsKey('API_URL_URBANITO')) {
//           final apiUrl = dotenv.env['API_URL_URBANITO'];
//           print('El archivo .env se cargó correctamente.');
//           print('Valor de API_URL_URBANITO: $apiUrl');
//         } else {
//           print(
//               'No se encontró la variable API_URL_URBANITO en el archivo .env.');
//         }
//       }

//       // await locationServiceUrbanito.sendLocationData(
//       //     position.latitude, position.longitude, timeStamp);
//     }

//     // Send data to the main isolate.
//     sendPort?.send(_eventCount);

//     _eventCount++;
//   }

//   // Called when the notification button on the Android platform is pressed.
//   @override
//   Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
//     print('onDestroy');
//   }

//   // Called when the notification button on the Android platform is pressed.
//   @override
//   void onNotificationButtonPressed(String id) {
//     print('onNotificationButtonPressed >> $id');

//     // open app
//     // _sendPort?.send('onNotificationButtonPressed');
//   }

//   // Called when the notification itself on the Android platform is pressed.
//   //
//   // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
//   // this function to be called.
//   @override
//   void onNotificationPressed() {
//     // Note that the app will only route to "/resume-route" when it is exited so
//     // it will usually be necessary to send a message through the send port to
//     // signal it to restore state when the app is already started.
//     FlutterForegroundTask.launchApp("");
//     print('onNotificationPressed');
//     _sendPort?.send('onNotificationPressed');
//   }
// }

// String getFormattedTimestamp() {
//   final now = DateTime.now();
//   final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
//   return formatter.format(now);
// }
