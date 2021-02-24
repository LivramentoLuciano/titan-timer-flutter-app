// Objeto Bluetooth que representara la conexion con el 'Cronometro BT'
// Tiene distitnas cuestions asociadas al uso de Bluetooth -> Flutter_blue (veerrr)
// y metodos para enviar datos asociados a la interfaz de mi App (sendPlay, sendPause, sendRoundUp, etc)

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

// Constants
final String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb";
final String CHARACTERISTIC_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb";
final String TARGET_DEVICE_NAME = "Cronometro";

final String TRAMA_INI = '{';
final String TRAMA_END = '}';
final String TRAMA_SEP = ';';

// Cronometro Bluetooth Class
class CronometroBluetooth with ChangeNotifier {
  // Estos son generales -> Deberian estar por fuera de CronometroBluetooth
  FlutterBlue flutterBlue;
  StreamSubscription<ScanResult> scanSubscription;
  List<BluetoothDevice> scanResults;
  List<BluetoothDevice> targetDevicesList;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristics;
  StreamSubscription<BluetoothDeviceState> stateSubscription;
  BluetoothDeviceState state;

  CronometroBluetooth()
      : flutterBlue = FlutterBlue.instance,
        targetDevicesList = [];

  sendPlay() => "Envia Play a BT";
  sendPause() => "Envia Pause a BT";
  sendRoundUp() => "Envia RoundUp a BT";
  sendRoundDown() => "Envia RoundDown a BT";

  // Estos metodos son generales -> Tamb creo que deberian estar por fuera de CronometroBluetooth
  btScan() {
    scanResults = [];
    scanSubscription =
        flutterBlue.scan(timeout: Duration(seconds: 5)).listen((result) {
      scanResults.add(result.device);
      if (isCronometroTitan(result)) {
        if (!targetDevicesList.contains(result.device))
          targetDevicesList.add(result.device);
      }
    }, onDone: () {
      print("Termino el scanStream");
    });
  }

  _stopScan() {
    flutterBlue.stopScan();
    scanSubscription.cancel();
  }

  _connect() async {
    if (targetDevice == null) return;
    await targetDevice.connect();
    _discoverServices();
  }

  _discoverServices() async {
    if (targetDevice == null) return;
    List<BluetoothService> services = await targetDevice.discoverServices();

    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID)
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristics = characteristic;
            // connected !!
          }
        });
    });
  }

  disconect() {}

  int get targetsAvailable => targetDevicesList.length;

  bool isCronometroTitan(ScanResult result) =>
      result.device.name == TARGET_DEVICE_NAME;
}
