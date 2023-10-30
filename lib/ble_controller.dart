
import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
class BleController extends GetxController {
  final flutterReactiveBle = FlutterReactiveBle();
  StreamSubscription? _scanSubscription;
  final _devices = <String, DiscoveredDevice>{}.obs;

Stream<List<DiscoveredDevice>> get devicesStream => _devices.stream.map((map) => map.values.toList());

  Future scanDevices() async {
    var blePermission = await Permission.bluetoothScan.status;
    if (blePermission.isDenied) {
      if (await Permission.bluetoothScan.request().isGranted) {
        if (await Permission.bluetoothConnect.request().isGranted) {
          _scanSubscription = flutterReactiveBle.scanForDevices(
            withServices: [],
            scanMode: ScanMode.lowLatency,
            requireLocationServicesEnabled: true,
          ).listen((device) {
            _devices[device.id] = device;
            print('Device name: ${device.name}, Device id: ${device.id}');
          });
        }
      }
    } else {
      _scanSubscription = flutterReactiveBle.scanForDevices(
        withServices: [],
        scanMode: ScanMode.lowLatency,
        requireLocationServicesEnabled: true,
      ).listen((device) {
        _devices[device.id] = device;
        print('Device name: ${device.name}, Device id: ${device.id}');
      });
    }
  }

  void stopScanning() {
    _scanSubscription?.cancel();
}
}