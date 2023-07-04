// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MyLocationComponent extends StatefulWidget {
//   const MyLocationComponent({Key? key}) : super(key: key);

//   @override
//   State<MyLocationComponent> createState() => _MyLocationComponentState();
// }

// class _MyLocationComponentState extends State<MyLocationComponent> {
//   String text = "Current Date";

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       viewServiceIsRunning();
//     });
//   }

//   Future<void> viewServiceIsRunning() async {
//     final service = FlutterBackgroundService();
//     bool isRunning = await service.isRunning();
//     final permissionStatus = await Permission.locationWhenInUse.status;

//     print('isRunning: $permissionStatus');
//     if (isRunning && permissionStatus.isGranted) {
//       final location = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       print('Location: $location');
//     }

//     if (isRunning) {
//       text = 'Stop Service';
//     } else {
//       text = 'Start Service';
//     }
//     setState(() {});
//   }

//   // hacer un print cada 2 minutos con control de errores
//   // Future<void> sendLocationRest() async {}

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           // Centro de los componentes
//           child: Container(
//             width: double.infinity, // Ancho del contenedor
//             color: const Color(0x990066a9), // Fondo azul noche
//             child: Column(
//               mainAxisAlignment:
//                   MainAxisAlignment.center, // Centrar verticalmente
//               children: [
//                 ElevatedButton(
//                   child: const Text("Foreground Mode"),
//                   onPressed: () {
//                     FlutterBackgroundService().invoke("setAsForeground");
//                   },
//                 ),
//                 ElevatedButton(
//                   child: const Text("Background Mode"),
//                   onPressed: () {
//                     FlutterBackgroundService().invoke("setAsBackground");
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text(text),
//                   onPressed: () async {
//                     final service = FlutterBackgroundService();
//                     var isRunning = await service.isRunning();
//                     if (isRunning) {
//                       service.invoke("stopService");
//                     } else {
//                       service.startService();
//                     }

//                     if (!isRunning) {
//                       text = 'Stop Service';
//                     } else {
//                       text = 'Start Service';
//                     }
//                     setState(() {});
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
