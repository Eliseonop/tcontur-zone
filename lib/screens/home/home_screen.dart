// import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
// import 'package:tcontur_zone/screens/home/pages/location/forent_component.dart';
// import 'package:tcontur_zone/screens/home/pages/location/test_bg_fetch.dart';
import 'package:tcontur_zone/screens/home/pages/location/test_location.dart';
// import 'package:tcontur_zone/screens/home/pages/location/location_page.dart';
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

  Future<void> goComprobate(context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GeolocatorApp(),
      ),
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
          backgroundColor: Colors.indigoAccent,
          title: const Text('Tcontur Zone'),
          centerTitle: true,
        ),
        drawer: const Drawer(
          child: MySettingPage(),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Text('Home Screen'),
          ),
        ),
      ),
    );
  }
}
