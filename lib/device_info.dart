import 'dart:async';
import 'package:platform_device_id/platform_device_id.dart';

class DeviceInfo {
  static final DeviceInfo _instance = DeviceInfo._internal();
  factory DeviceInfo() => _instance;

  DeviceInfo._internal();

  static DeviceInfo get instance => _instance;

  String? deviceId;

  Future<void> getDeviceId() async {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } catch (e) {
      deviceId = 'Error getting device ID: $e';
    }
  }

  String? getDeviceIdValue() {
    return deviceId;
  }
}