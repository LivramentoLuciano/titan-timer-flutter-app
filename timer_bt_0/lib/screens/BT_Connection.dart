import 'package:flutter/material.dart';
import 'dart:async';
import 'package:timer_bt_0/screens/ConfigRoutine.dart';
import 'package:timer_bt_0/widgets/StopwatchView.dart';
import 'package:timer_bt_0/widgets/routineModel.dart';
import 'package:timer_bt_0/widgets/BT_methods.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert' show utf8;

class BT_Connection_Screen extends StatefulWidget {
  @override
  _BT_Connection_ScreenState createState() => _BT_Connection_ScreenState();
}

class _BT_Connection_ScreenState extends State<BT_Connection_Screen> {
  String connectionText;
  bool _btLoading, _btVinculated, _btConnected;
  bool _targetDeviceFound, _anyDeviceFound;
  BluetoothDeviceState _deviceState; // Por si desea volver a generar una nueva rutina sin cerrar la app
  StreamSubscription<BluetoothDeviceState> _deviceStateSubscription;

  @override
  void initState() {
    connectionText = "";
    scanResultsList = [];
    _btLoading = false;
    _btVinculated = false;
    _btConnected = false;
    _targetDeviceFound = false;
    _anyDeviceFound = false;
    if (targetDevice != null){
      // Por si desea volver a generar una nueva rutina sin cerrar la app
      _deviceStateSubscription = targetDevice.state.listen((state) {
        setState(() {
          _deviceState = state;
          print("ACTUALIZA STREAM STATE EN CONNECTION SCREEN: $_deviceState");
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_deviceStateSubscription != null){
      _deviceStateSubscription.cancel();
    }
    super.dispose();
  }

  _scanBT() {
    setState(() {
      _btLoading = true;
      connectionText = "Buscando: ${TARGET_DEVICE_NAME}";
      //scanResultsList = []; //probando, reinicio el Scan (limpio la lista de dispos)
    });

    scanSubScription =
        flutterBlue.scan(timeout: Duration(seconds: 5)).listen((scanResult) {
      if (scanResult.device.name != null && scanResult.device.name != "")
        setState(() {
          scanResultsList.add(scanResult.device);
          _anyDeviceFound = true;
        });
      if (scanResult.device.name == TARGET_DEVICE_NAME) {
        print(
            "SE ENCONTRÓ EL DISPOSITIVO TARGET - SE DETIENE EL SCANNING CORRECTAMENTE Y SE SIGUE CON EL NORMAL FUNCIONAMIENTO");
        setState(() {
          connectionText = "Vinculado a: ${scanResult.device.name}";
          _targetDeviceFound = true;
          _btLoading = false;
          _btVinculated = true;
          routine.isWithBT = true;
        });
        _stopScan();
        targetDevice = scanResult.device;
        _connectToDevice();
      }
    }, onDone: () => _onDoneScan()); //_stopScan());
  }

  _onDoneScan() {
    if (_anyDeviceFound) {
      print(
          "Durante el scanning NO se encontró el TargetDevice, pero se encontraron los siguientes dispositivos: ");
      scanResultsList
          .forEach((device) => print("Nombre Dispositivo: ${device.name}"));
    } else {
      print(
          "No se encontró NINGÚN Device -> SE DEBERÁ RESCANNEAR o ver qué hacer");
    }
    _stopScan();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Falló la conexión Bluetooth"),
        content: Text(
            "Asegúrese que el Cronómetro Bluetooth esté encendido y vuelva a intentarlo."),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop("retry");
            },
            child: Text("REINTENTAR"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop("cancel");
            },
            child: Text("CANCELAR"),
          ),
        ],
      ),
    ).then((result) {
      print(result);
      result == "retry" ? _retryScanning() : _cancelBTConnection();
    });
  }

  _stopScan() {
    print("STOPING SCAN");
    flutterBlue.stopScan();
    scanSubScription?.cancel();
    //scanSubScription.cancel();
    scanSubScription = null;
  }

  _retryScanning() {
    print("Manda a reescanear");
    setState(() {
      connectionText = "";
      scanResultsList = [];
      _btLoading = false;
      _btVinculated = false;
      _btConnected = false;
      _targetDeviceFound = false;
      _anyDeviceFound = false;
    });
    _scanBT();
  }

  _cancelBTConnection() {
    print("Manda a cancelar");
    setState(() {
      connectionText = "";
      scanResultsList = [];
      _btLoading = false;
      _btVinculated = false;
      _btConnected = false;
      _targetDeviceFound = false;
      _anyDeviceFound = false;
    });
  }

  _connectToDevice() async {
    if (targetDevice == null) return;

    setState(() {
      connectionText = "Conectando...";
    });

    await targetDevice.connect();
    setState(() {
      connectionText = "Conectado a ${targetDevice.name}";
    });

    discoverServices();
  }

  _disconnectFromDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();
    print("desconecta");
    setState(() {
      connectionText = "Device Disconnected";
    });
  }

  discoverServices() async {
    if (targetDevice == null) return;
    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            setState(() {
              _btConnected = true;
              //connectionText = "Conectado con ${targetDevice.name}. Listo !";
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Routine _routine = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Conexión Bluetooth"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _btLoading || _btVinculated
                  ? connectionText
                  : (_deviceState == BluetoothDeviceState.connected) ? "Conectado a ${targetDevice.name}" : "Conectar al cronómetro Bluetooth", //cambié por App simplificada sin Timer (sólo funciona como control remoto, osea que SI o SI NECESITA EL BLUETOOTH) //"¿Desea conectar al cronómetro Bluetooth?",
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(fontSize: 30, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Visibility(
              visible: _btLoading,
              child: CircularProgressIndicator(),
            ),
            Visibility(
              visible: !_btLoading || (_deviceState == BluetoothDeviceState.connected),
              child: FloatingActionButton(
                onPressed: _btConnected || (_deviceState == BluetoothDeviceState.connected)
                    ? () {
                        // Cambiar a screen Timer
                        Navigator.of(context).pushReplacementNamed(
                          '/RoutinePlay',
                          //arguments:,
                        );
                      }
                    : () {
                        _scanBT();
                      },
                child:
                    _btVinculated || (_deviceState == BluetoothDeviceState.connected)? Icon(Icons.check) : Icon(Icons.bluetooth),
                backgroundColor: _btConnected || (_deviceState == BluetoothDeviceState.connected)
                    ? Colors.green
                    : _btVinculated
                        ? Colors.yellow
                        : Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: false, //cambié por App simplificada sin Timer (sólo funciona como control remoto, osea que SI o SI NECESITA EL BLUETOOTH) // !(_btLoading || _btVinculated || (_deviceState == BluetoothDeviceState.connected)),
        child: RaisedButton(
          onPressed: () {
            setState(() {
              routine.isWithBT = false; //puse por defecto isWithBT true, para permitir que si termino una rutina y quiero volver a empezar sin cerrar la app (el BT sigue conectado) y puedo configurar una rutina nueva 
            });
            //cambiar screen a Timer
            Navigator.of(context).pushReplacementNamed(
              '/RoutinePlay',
              //arguments: ,
            );
          },
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Colors.white)),
          child: Text(
            "Omitir",
            style: Theme.of(context).textTheme.display1.copyWith(
                  fontSize: 14,
                  color: Colors.black,
                ),
          ),
        ),
      ),
    );
  }
}
