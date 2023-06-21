import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  MyMapState createState() => MyMapState();
}

class MyMapState extends State<MyMap> {
  final MapController mapController = MapController();
  LatLng currentPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
  }

  // void getCurrentLocation() async {
  //   final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  //   try {
  //     final position = await geolocatorPlatform.getCurrentPosition();
  //     setState(() {
  //       currentPosition = LatLng(position.latitude, position.longitude);
  //       mapController.move(currentPosition, 13.0);
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Tracker',
      home: Scaffold(
        body: FlutterMap(
          nonRotatedChildren: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
          ],
          mapController: mapController,
          options: MapOptions(
            center: currentPosition,
            zoom: 13.0,
            boundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(8.0)),
          ),
        ),
      ),
    );
  }
}
