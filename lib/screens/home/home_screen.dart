import 'package:flutter/material.dart';
import 'package:tcontur_zone/screens/home/pages/location/test_location.dart';
import 'package:tcontur_zone/screens/home/pages/settings/settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
        drawer: const Drawer(
          child: MySettingPage(),
        ),
        body: const GeolocatorApp(),
      ),
    );
  }
}
