// import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcontur_zone/provider/provider_user.dart';
import 'package:tcontur_zone/provider/provider_page.dart';
// import 'package:tcontur_zone/screens/home/pages/location/forent_component.dart';
// import 'package:tcontur_zone/screens/home/pages/location/test_bg_fetch.dart';
import 'package:tcontur_zone/screens/home/pages/location/location_component.dart';
// import 'package:tcontur_zone/screens/home/pages/location/location_page.dart';
import 'package:tcontur_zone/screens/home/pages/drawer/my_drawer.dart';
import 'package:tcontur_zone/screens/home/pages/web/my-webview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var currentPage = DrawerSections.location;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);

    final userProvider =
        Provider.of<UserProvider>(context); // Obtén instancia de PageProvider
    var currentPage = pageProvider.currentPage;

    print('Token en HomeScreen: ${userProvider.user?.token}');

    return WillPopScope(
      onWillPop: () async {
        return false; // Evitar que se pueda regresar al presionar el botón de retroceso
      },
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          // bg color #125183
          backgroundColor: const Color(0xFF125183),
          title: const Text('Tcontur Zone'),
          centerTitle: true,
        ),
        drawer: MyDrawer(),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Color(0xFF125183),
                child: getPageContent(currentPage),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPageContent(DrawerSections page) {
    switch (page) {
      case DrawerSections.location:
        return GeolocatorApp();
      case DrawerSections.web:
        return ViewWeb();
      default:
        return Container();
    }
  }
}
