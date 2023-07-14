import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcontur_zone/screens/home/home_screen.dart';
// import 'package:tcontur_zone/screens/welcome/welcome_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tcontur_zone/screens/login/login_screen.dart';
import 'package:tcontur_zone/services/notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestNotificationPermission();
  // await initNotifications();
  await dotenv.load();

  runApp(const MyApp());
  // LocationServiceUrbanito().checkLocationStatus();
//   BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  configLoading();

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // flutterLocalNotificationsPlugin
  //     .getNotificationAppLaunchDetails()
  //     .asStream()
  //     .listen((event) {
  //   print(
  //       'event =>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' +
  //           event.toString());
  //   if (event?.didNotificationLaunchApp ?? false) {
  //     print('didNotificationLaunchApp');
  //   }
  // });
}

Future<void> requestNotificationPermission() async {
  final permision = await Geolocator.checkPermission();
  if (permision == LocationPermission.denied ||
      permision == LocationPermission.deniedForever) {
    await Geolocator.requestPermission();
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..maskType = EasyLoadingMaskType.black
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black.withOpacity(0.5)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Future<bool> initializeApp() async {
    await Future.delayed(const Duration(seconds: 4));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? user = prefs.getString('user');
    print(token);
    print(user);
    return user != null;
  }

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
  }

  // await Navigator.push(
  //   context,
  //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
  // );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra la animación de splash mientras se espera el resultado
          return AnimatedSplashScreen(
            splash: Image.asset('assets/images/icon.png'),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            duration: 3000,
            animationDuration: const Duration(milliseconds: 3000),
            nextScreen:
                Container(), // Puedes reemplazarlo con tu siguiente pantalla// No es necesario definir una función vacía
          );
        } else if (snapshot.hasError) {
          // Maneja el caso de error
          return Text('Error: ${snapshot.error}');
        } else {
          // Navega a la pantalla correspondiente según el resultado
          final bool isLoggedIn = snapshot.data!;
          return isLoggedIn ? const HomeScreen() : const LoginScreen();
        }
      },
    );
  }
}
