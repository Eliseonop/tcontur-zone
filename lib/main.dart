import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcontur_zone/screens/home/home_screen.dart';
import 'package:tcontur_zone/screens/welcome/welcome_screen.dart';
import 'package:tcontur_zone/services/background.dart';
//import 'package:tcontur_zone/services/notification.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await initNotifications();
  await Permission.notification.isDenied.then((value) => {
        if (value)
          {
            Permission.notification.request(),
          }
      });

  runApp(const MyApp());
  configLoading();
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
      title: 'Your App',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            color: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      builder: EasyLoading.init(),
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
  @override
  void initState() {
    super.initState();
    navigateToNextScreen(context);
  }

  Future<void> navigateToNextScreen(context) async {
    // await Future.delayed(const Duration(
    //     seconds: 1)); // Retardo de 3 segundos (ajústalo según tus necesidades)

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? user = prefs.getString('user');
    print(token);
    print(user);
    if (token == null && user == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Image.asset('assets/images/icon.png'),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        duration: 3000,
        animationDuration: const Duration(milliseconds: 3000),
        nextScreen:
        WelcomeScreen(), // Puedes reemplazarlo con tu siguiente pantalla
        function: () => navigateToNextScreen(
            context) // Función que se ejecutará para pasar a la siguiente pantalla
    );
  }
}
