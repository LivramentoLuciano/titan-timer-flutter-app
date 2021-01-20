import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert' show utf8;

final String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb";
final String CHARACTERISTIC_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb";
final String TARGET_DEVICE_NAME = "Cronometro";

final String INICIO_TRAMA = '{';
final String FIN_TRAMA = '}';
final String SEPARADOR = ';';

FlutterBlue flutterBlue = FlutterBlue.instance;
StreamSubscription<ScanResult> scanSubScription;
StreamSubscription<BluetoothDeviceState> deviceStateSubscription;
BluetoothDeviceState deviceState;

BluetoothDevice targetDevice;
BluetoothCharacteristic targetCharacteristic;

List<BluetoothDevice> scanResultsList;

String data2Trama(List<dynamic> datos) {
  String trama = "";
  datos.forEach((dato) {
    trama = trama + "$dato" + SEPARADOR;
  });
  trama = INICIO_TRAMA + trama + FIN_TRAMA;
  return trama;
}

Future<String> enviarBT(String data) {
  //asyn {
  if (targetCharacteristic == null)
    return Future.error(
        "Error: Característica Nula"); // Future.value('Característica Nula');
  String _value = "";

  List<int> bytes = utf8.encode(data);
  bool _connected = false;

  if (isBTConnected()) {
    print("ESTA CONECTADO -> MANDA EL MENSAJE");
    targetCharacteristic.write(bytes);
    _value = "ok";
  } else {
    print("NO ESTÁ CONECTADO AL TARGET -> NO MANDA EL MENSAJE");
    print(
        "VER COMO MANEJAR EL ERROR, ¿Reconectar y/o Resincronizar la rutina?");
    _value = "target off";
  }

  /*await flutterBlue.connectedDevices.then((listDevices) {
    if (listDevices.length > 0) {
      listDevices.forEach((btDevice) {
        //print("Dispositivo Conectado ${btDevice.name}");
        if (btDevice.name == TARGET_DEVICE_NAME) {
          print("ESTOY CONECTADO AL TARGET");
          _connected = true;
          targetCharacteristic.write(bytes);
          _value = "ok";
        }
      });
    }
    if (_connected == false) {
      print("NO ESTÁ CONECTADO AL TARGET -> NO MANDA EL MENSAJE");
      print(
          "VER COMO MANEJAR EL ERROR, ¿Reconectar y/o Resincronizar la rutina?");
      _value = "target off";
    }
  });*/
  return Future.value(_value);
}

/// En teoría esta forma de chequearlo sirve, porque solo se te dice si está 'connected' mediante FlutterBlue
/// (por lo que no me dirá que está conectado si, por ejemplo, por otra app se conecta a parlante Bluetooth por decir algo)
bool isBTConnected() {
  return (deviceState == BluetoothDeviceState.connected);
}

/*
bool isBTConnected() {
  bool _isConnected = false;
  targetDevice.state.listen((state) {
    if (state == BluetoothDeviceState.connected) {
      _isConnected = true;
    }
  });
  return _isConnected;
}

bool isBTDisconnected() {
  bool _isDisconnected = false;
  targetDevice.state.listen((state) {
    if (state == BluetoothDeviceState.disconnected) {
      _isDisconnected = true;
    }
  });
  return _isDisconnected;
}

bool isBTConnecting() {
  bool _isConnecting = false;
  targetDevice.state.listen((state) {
    if (state == BluetoothDeviceState.connecting) {
      _isConnecting = true;
    }
  });
  return _isConnecting;
}

bool isBTDisconnecting() {
  bool _isDisconnecting = false;
  targetDevice.state.listen((state) {
    if (state == BluetoothDeviceState.disconnecting) {
      _isDisconnecting = true;
    }
  });
  return _isDisconnecting;
}
*/
