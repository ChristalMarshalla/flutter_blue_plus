
import 'package:bluetooth_flut_blue/ble_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BLE SCANNER"),
        centerTitle: true,
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (controller) {
          return Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: StreamBuilder<List<DiscoveredDevice>>(
                  stream: controller.devicesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final devices = snapshot.data;
                      return ListView.builder(
                        itemCount: devices!.length,
                        itemBuilder: (context, index) {
                          final device = devices[index];
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(device.name),
                              subtitle: Text(device.id),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("No Device Found"),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          );
        },
      ),
      floatingActionButton: GetBuilder<BleController>(
        init: BleController(),
        builder: (controller) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () => controller.scanDevices(),
                child: const Icon(Icons.play_arrow),
              ),
              const SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                onPressed: () => controller.stopScanning(),
                child: const Icon(Icons.stop),
              ),
            ],
          );
        },
      ),
    );
  }
}