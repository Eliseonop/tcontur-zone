import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcontur_zone/auth/models/empresas_response.dart';
// import 'package:tcontur_zone/provider/provider_empresa.dart';
import 'package:tcontur_zone/provider/provider_user.dart';

class ViewWeb extends StatefulWidget {
  const ViewWeb({Key? key}) : super(key: key);

  @override
  ViewWebState createState() => ViewWebState();
}

class ViewWebState extends State<ViewWeb> {
  double progress = 0;
  late InAppWebViewController inAppWebViewController;

  Future<EmpresaResponse?> getEmpresa() async {
    // delay
    await Future.delayed(Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final empresa = prefs.getString('selectedEmpresa');

    if (empresa != null) {
      // Convierte el JSON (String) a un Map<String, dynamic>
      final empresaData = json.decode(empresa);
      // Crea una instancia de EmpresaResponse desde el Map
      return EmpresaResponse.fromJson(empresaData);
    }

    return null;
  }

  @override
  void initState() {
    // clearCacheWeb();
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant ViewWeb oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> clearCacheWeb() async {
    await inAppWebViewController.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final token = userProvider.user?.token;

    return FutureBuilder<EmpresaResponse?>(
      future: getEmpresa(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // If the future completes successfully with data, render the InAppWebView
          if (snapshot.data is EmpresaResponse) {
            final nameData = snapshot.data?.getNameNotSpace();
            print('---->-->-->-->-->--> dataname sin espacios $nameData');
            final url = Uri.parse(
                'https://$nameData.tcontur.pe/verify-token?token=$token');
            print('---->-->-->-->-->--> LA URL ESTA AQUI: $url');
            return InAppWebView(
              initialUrlRequest: URLRequest(
                url: url,
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                controller.clearCache();
                inAppWebViewController = controller;
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        } else {
          // If the future completes without data (null), show a message or perform an action
          return const Center(
            child: Text('...'),
          );
        }
      },
    );
  }
}
