import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MyLocationComponent extends StatefulWidget {
  const MyLocationComponent({Key? key}) : super(key: key);

  @override
  State<MyLocationComponent> createState() => _MyLocationComponentState();
}

class _MyLocationComponentState extends State<MyLocationComponent> {
  String text = "Current Date";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewServiceIsRunning();
      requestLocationPermission();
    });
    inUpdateBackgroundService();
  }

  void inUpdateBackgroundService() {
    final service = FlutterBackgroundService().on('update');

    print('linea 23 page location' + service.toString());
  }
  Future<void> requestLocationPermission() async {
    final bool permission = await Permission.locationWhenInUse.isDenied;

    // Si permission es false, mostrar una alerta que pida activar la ubicación.
    if (permission) {
      await Future.delayed(Duration(seconds: 5)); // Retraso de 5 segundos

      final value = await Permission.locationWhenInUse.request();
      if (value.isGranted) {
        final service = FlutterBackgroundService();
        // Obtener la ubicación actual y ejecutar el servicio en segundo plano
        var isRunning = await service.isRunning();
        if (isRunning) {
          print('linea 43 page location' + service.toString());
        } else {
          service.startService().then((value) => {


            if(value){
              print('linea 49 page location' + value.toString()),
    FlutterBackgroundService().invoke("setAsForeground"),
            }
          });

        }
      }
    }
  }


  Future<void> viewServiceIsRunning() async {
    final service = FlutterBackgroundService();
    bool isRunning = await service.isRunning();
    if (isRunning) {
      text = 'Stop Service';
    } else {
      text = 'Start Service';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          // Centro de los componentes
          child: Container(
            width: double.infinity, // Ancho del contenedor
            color: const Color(0x990066a9), // Fondo azul noche
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centrar verticalmente
              children: [
                ElevatedButton(
                  child: const Text("Foreground Mode"),
                  onPressed: () {
                    FlutterBackgroundService().invoke("setAsForeground");
                  },
                ),
                ElevatedButton(
                  child: const Text("Background Mode"),
                  onPressed: () {
                    FlutterBackgroundService().invoke("setAsBackground");
                  },
                ),
                ElevatedButton(
                  child: Text(text),
                  onPressed: () async {
                    final service = FlutterBackgroundService();
                    var isRunning = await service.isRunning();
                    if (isRunning) {
                      service.invoke("stopService");
                    } else {
                      service.startService();
                    }

                    if (!isRunning) {
                      text = 'Stop Service';
                    } else {
                      text = 'Start Service';
                    }
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
