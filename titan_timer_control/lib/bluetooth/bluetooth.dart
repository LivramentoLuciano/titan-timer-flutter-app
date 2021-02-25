// Objeto Bluetooth que representara la conexion con el 'Cronometro BT'
// Tiene distitnas cuestions asociadas al uso de Bluetooth -> Flutter_blue (veerrr)
// y metodos para enviar datos asociados a la interfaz de mi App (sendPlay, sendPause, sendRoundUp, etc)

import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

// Constants
final String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb";
final String CHARACTERISTIC_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb";
final String TARGET_DEVICE_NAME = "Cronometro";

final String TRAMA_INI = '{';
final String TRAMA_END = '}';
final String TRAMA_SEP = ';';
final String START_HEADER = "S";
final String PAUSE_HEADER = "P";
final String RESUME_HEADER = "s";
final String ROUND_UP_HEADER = "R";
final String ROUND_DOWN_HEADER = "r";
final String REPLAY_HEADER = "b";
final String FORWARD_HEADER = "f";

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

  sendStart() {
    String _header = START_HEADER;
    List<String> _datos = [];
    _sendData(_header, _datos);
  }

  sendPause() {
    String _header = PAUSE_HEADER;
    List<String> _datos = [];
    _sendData(_header, _datos);
  }

  sendRoundUp() {
    String _header = ROUND_UP_HEADER;
    List<String> _datos = [];
    _sendData(_header, _datos);
  }

  sendRoundDown() {
    String _header = ROUND_DOWN_HEADER;
    List<String> _datos = [];
    _sendData(_header, _datos);
  }

  sendReplay() {
    String _header = REPLAY_HEADER;
    List<String> _datos = [];
    _sendData(_header, _datos);
  }

  sendForward() {
    String _header = FORWARD_HEADER;
    List<String> _datos = [];
    _sendData(_header, _datos);
  }

  // Future -> Devolver msj de "errores", "ok"
  // Recibo 'header' y 'datos []' -> Armo trama antes de enviar
  Future<String> _sendData(String _header, List<String> _datos) {
    if (targetCharacteristics == null)
      return Future.error("Error: Caracteristica Nula");

    String _trama = _makeTrama(header: _header, datos: _datos);
    List<int> bytes = utf8.encode(_trama);
    targetCharacteristics.write(bytes);
    print("Enviando: $_trama");
  }

  String _makeTrama({@required String header, @required List<String> datos}) {
    String _trama = TRAMA_INI + header + TRAMA_SEP;
    if (datos.isNotEmpty)
      datos.forEach((dato) {
        _trama += dato + TRAMA_SEP;
      });
    _trama += TRAMA_END;
    return _trama;
  }

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

  stopScan() {
    flutterBlue.stopScan();
    scanSubscription.cancel();
  }

  connect() async {
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
