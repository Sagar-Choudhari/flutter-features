import 'package:flutter/material.dart';
import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';

class CheckImei extends StatefulWidget {
  const CheckImei({Key? key}) : super(key: key);

  @override
  State<CheckImei> createState() => _CheckImeiState();
}

class _CheckImeiState extends State<CheckImei> {
  String imei = "";
  Map<String, dynamic> data = {'': ''};
  bool isPhysicalDevice = false;
  var board = "",
      bootloader = "",
      brand = "",
      device = "",
      display = "",
      displayMetrics = "",
      fingerprint = "",
      hardware = "",
      host = "",
      id = "",
      manufacturer = "",
      model = "",
      product = "",
      serialNumber = "",
      tags = "",
      type = "";

  var version = '';
  List<String> supported32BitAbis = [],
      supported64BitAbis = [],
      supportedAbis = [],
      systemFeatures = [];

  Future<void> printInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // debugPrint('Running on ${androidInfo.board}');
    // debugPrint('Running on ${androidInfo.bootloader}');
    // debugPrint('Running on ${androidInfo.brand}');
    // debugPrint('Running on ${androidInfo.data}');
    // debugPrint('Running on ${androidInfo.device}');
    // debugPrint('Running on ${androidInfo.display}');
    // debugPrint('Running on ${androidInfo.displayMetrics}');
    // debugPrint('Running on ${androidInfo.fingerprint}');
    // debugPrint('Running on ${androidInfo.hardware}');
    // debugPrint('Running on ${androidInfo.host}');
    // debugPrint('Running on ${androidInfo.id}');
    // debugPrint('Running on ${androidInfo.isPhysicalDevice}');
    // debugPrint('Running on ${androidInfo.manufacturer}');
    // debugPrint('Running on ${androidInfo.model}');
    // debugPrint('Running on ${androidInfo.product}');
    // debugPrint('Running on ${androidInfo.serialNumber}');
    // debugPrint('Running on ${androidInfo.supported32BitAbis}');
    // debugPrint('Running on ${androidInfo.supported64BitAbis}');
    // debugPrint('Running on ${androidInfo.supportedAbis}');
    // debugPrint('Running on ${androidInfo.systemFeatures}');
    // debugPrint('Running on ${androidInfo.tags}');
    // debugPrint('Running on ${androidInfo.type}');
    // debugPrint('Running on ${androidInfo.version}');
    setState(() {
      board = androidInfo.board;
      bootloader = androidInfo.bootloader;
      brand = androidInfo.brand;
      data = androidInfo.data;
      device = androidInfo.device;
      display = androidInfo.display;
      fingerprint = androidInfo.fingerprint;
      hardware = androidInfo.hardware;
      host = androidInfo.host;
      id = androidInfo.id;
      isPhysicalDevice = androidInfo.isPhysicalDevice;
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
      product = androidInfo.product;
      serialNumber = androidInfo.serialNumber;
      supported32BitAbis = androidInfo.supported32BitAbis;
      supported64BitAbis = androidInfo.supported64BitAbis;
      supportedAbis = androidInfo.supportedAbis;
      systemFeatures = androidInfo.systemFeatures;
      tags = androidInfo.tags;
      type = androidInfo.type;
      version = androidInfo.version as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMEI'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () async {
                  printInfo();
                  // getImeiNumber();
                },
                child: const Text('Get Info'),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('IMEI: $imei\n'),
              const SizedBox(
                height: 10,
              ),
              Text('Board: $board\n'),
              const SizedBox(
                height: 10,
              ),
              Text('Bootloader: $bootloader\n'),
              const SizedBox(
                height: 10,
              ),
              Text('Brand: $brand\n'),
              const SizedBox(
                height: 10,
              ),
              Text('Device: $device\n'),
              const SizedBox(
                height: 10,
              ),
              Text('fingerprint: $fingerprint\n'),
              const SizedBox(
                height: 10,
              ),
              Text('hardware: $hardware\n'),
              const SizedBox(
                height: 10,
              ),
              Text('host: $host\n'),
              const SizedBox(
                height: 10,
              ),
              Text('ID: $id\n'),
              const SizedBox(
                height: 10,
              ),
              Text('isPhysicalDevice: $isPhysicalDevice\n'),
              const SizedBox(
                height: 10,
              ),
              Text('manufacturer: $manufacturer\n'),
              const SizedBox(
                height: 10,
              ),
              Text('model: $model\n'),
              const SizedBox(
                height: 10,
              ),
              Text('product: $product\n'),
              const SizedBox(
                height: 10,
              ),
              Text('serialNumber: $serialNumber\n'),
              const SizedBox(
                height: 10,
              ),
              Text('supported32BitAbis: $supported32BitAbis\n'),
              const SizedBox(
                height: 10,
              ),
              Text('supported64BitAbis: $supported64BitAbis\n'),
              const SizedBox(
                height: 10,
              ),
              Text('supportedAbis: $supportedAbis\n'),
              const SizedBox(
                height: 10,
              ),
              Text('systemFeatures: $systemFeatures\n'),
              const SizedBox(
                height: 10,
              ),
              Text('tags: $tags\n'),
              const SizedBox(
                height: 10,
              ),
              Text('type: $type\n'),
              const SizedBox(
                height: 10,
              ),
              Text('version: ${version.toString()}\n'),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
