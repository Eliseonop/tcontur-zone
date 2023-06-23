import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tcontur_zone/screens/home/pages/location/location_page.dart';
import 'package:tcontur_zone/screens/home/pages/settings/settings_page.dart';
import 'package:tcontur_zone/services/background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _locationActive = false;
  final List<Widget> _screens = [
    const MyLocationComponent(),
    const MySettingPage(),
  ];
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    initializeServiceBackGround();
  }

  Future<void> requestLocationPermission() async {
    if (await Permission.locationWhenInUse.isDenied) {
      await Permission.locationWhenInUse.request().then((value) => {
            if (value.isGranted)
              {
                setState(() {
                  _locationActive = true;
                }),
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Evitar que se pueda regresar al presionar el botón de retroceso
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.follow_the_signs),
              label: 'Ubicación',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
