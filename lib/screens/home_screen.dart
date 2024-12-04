import 'package:flutter/material.dart';
import 'package:project2/screens/generate_code_screen.dart';
import 'package:project2/screens/input_code_screen.dart';
import 'package:project2/device_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Movie Night")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await DeviceInfo.instance.getDeviceId();
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GenerateCodeScreen(
                              deviceId: DeviceInfo.instance.getDeviceIdValue()),
                        ),
                      );
                    }
                  },
                  child: const Text("Start Session")),
              const SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: () async {
                    await DeviceInfo.instance.getDeviceId();
                    if (context.mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputCodeScreen(
                              deviceId: DeviceInfo.instance.getDeviceIdValue()),
                            ),
                          );
                    }
                  },
                  child: const Text("Enter Code"))
            ],
          ),
        ));
  }
}
