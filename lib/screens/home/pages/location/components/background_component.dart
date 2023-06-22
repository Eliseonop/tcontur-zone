import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class ServiceControlWidget extends StatefulWidget {
  @override
  _ServiceControlWidgetState createState() => _ServiceControlWidgetState();
}

class _ServiceControlWidgetState extends State<ServiceControlWidget> {
  String text = 'Stop Service';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            FlutterBackgroundService().invoke('setAsForeground');
          },
          child: const Text('Establecer como servicio en primer plano'),
        ),
        ElevatedButton(
          onPressed: () {
            FlutterBackgroundService().invoke('setAsBackground');
          },
          child: const Text('Establecer como servicio en segundo plano'),
        ),
        ElevatedButton(
          onPressed: () async {
            final service = FlutterBackgroundService();
            bool isRunning = await service.isRunning();
            if (isRunning) {
              service.invoke('stopService');
            } else {
              service.startService();
            }
            if (!isRunning) {
              setState(() {
                text = 'Stop Service';
              });
            } else {
              setState(() {
                text = 'Start Service';
              });
            }
          },
          child: Text(text),
        ),
      ],
    );
  }
}
