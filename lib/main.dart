import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tcontur_zone/provider/provider_empresa.dart';
import 'package:tcontur_zone/provider/provider_user.dart';
import 'package:tcontur_zone/provider/provider_page.dart';
import 'package:tcontur_zone/screens/home/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tcontur_zone/screens/login/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await requestNotificationPermission();
  // await initNotifications();
  await dotenv.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider()..checkLoginStatus(),
        ),
        ChangeNotifierProvider(create: (context) => PageProvider()),
        ChangeNotifierProvider(
            create: (context) => EmpresaProvider()..checkSelectedEmpresa()),
      ],
      child: const MyApp(),
    ),
  );

  configLoading();
}

// Future<void> requestNotificationPermission() async {
//   final permision = await Geolocator.checkPermission();
//   if (permision == LocationPermission.denied ||
//       permision == LocationPermission.deniedForever) {
//     await Geolocator.requestPermission();
//   }
// }

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
      debugShowCheckedModeBanner: true,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return AnimatedSplashScreen(
          splash: Image.asset('assets/images/icon.png'),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          duration: 2500,
          animationDuration: const Duration(milliseconds: 3000),
          nextScreen: userProvider.user != null ? HomeScreen() : LoginScreen(),
        );
      },
    );
  }
}
