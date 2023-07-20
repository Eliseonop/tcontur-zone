import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:tcontur_zone/provider/provider_user.dart';
// import 'package:tcontur_zone/auth/models/user_response.dart';
import 'package:tcontur_zone/provider/provider_page.dart';
import 'package:tcontur_zone/screens/login/login_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user; // Obtener el usuario del provider

    Future<void> logout(BuildContext context) async {
      // Llamar al método de logout en el provider
      FlutterBackgroundService().invoke('stopService');
      await userProvider.logout();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }

    final pageProvider = Provider.of<PageProvider>(context);

    void setPage(DrawerSections page) {
      pageProvider.setCurrentPage(page);
      Navigator.pop(context);
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/roads.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(user?.nombre ?? ''),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Image(
                  image: AssetImage('assets/images/icon.png'),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Estado del Servicio'),
            leading: const Icon(Icons.location_on_outlined),
            onTap: () => setPage(DrawerSections.location),
            selected: pageProvider.currentPage == DrawerSections.location,
          ),
          ListTile(
            title: const Text('Web'),
            leading: const Icon(Icons.web),
            onTap: () => setPage(DrawerSections.web),
            selected: pageProvider.currentPage == DrawerSections.web,
          ),
          const Divider(),
          ListTile(
            title: const Text('Cerrar sesión'),
            leading: const Icon(Icons.logout),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}
