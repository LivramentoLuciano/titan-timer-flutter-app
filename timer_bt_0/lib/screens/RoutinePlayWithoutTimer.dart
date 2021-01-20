import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timer_bt_0/screens/ConfigRoutine.dart';
import 'package:timer_bt_0/widgets/routineModel.dart';
import 'package:timer_bt_0/widgets/routineDetailsDisplay.dart';
import 'package:timer_bt_0/widgets/routineRoundSetDisplay.dart';
import 'package:timer_bt_0/widgets/BT_methods.dart';
import 'package:timer_bt_0/widgets/methods.dart';

import 'package:flutter_blue/flutter_blue.dart';

class RoutinePlayWithoutTimer_Screen extends StatefulWidget {
  @override
  _RoutinePlayWithoutTimer_ScreenState createState() =>
      _RoutinePlayWithoutTimer_ScreenState();
}

class _RoutinePlayWithoutTimer_ScreenState
    extends State<RoutinePlayWithoutTimer_Screen> {
  bool _started, _paused, _stopped, _resumed;

  String _connectionText;
  bool _btLoading, _btVinculated, _btConnected;
  bool _targetDeviceFound, _anyDeviceFound;
  bool _tryReconnecting;

  @override
  void initState() {
    _started = false;
    _paused = false;
    _stopped = true;
    _resumed = false;
    routine.state = 'NONE';
    _connectionText =
        routine.isWithBT ? "Vinculado a ${targetDevice.name}" : "NONE";
    scanResultsList = [];
    _btLoading = false;
    _btVinculated = false;
    _btConnected = false;
    _targetDeviceFound = false;
    _anyDeviceFound = false;
    _tryReconnecting = false;

    if (routine.isWithBT) {
      deviceStateSubscription = targetDevice.state.listen((state) {
        setState(() {
          deviceState = state;
          print("ACTUALIZA STREAM STATE: $deviceState");
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (deviceStateSubscription != null) {
      deviceStateSubscription.cancel();
    }
    super.dispose();
  }

  void _start() {
    setState(() {
      _started = true;
      _paused = false;
      _stopped = false;
      _resumed = false;
      routine.state = 'init';
      routine.actualRound = 1;
      routine.actualSet = 1;
    });
    print("start");

    if (routine.isWithBT) {
      _enviarBTwitCheck(data2Trama(routine.datosStartRoutineBT()));
    }
  }

  void _pause() {
    print("Pausa");
    setState(() {
      _paused = true;
      _started = false;
      _stopped = false;
      _resumed = false;
    });
    if (routine.isWithBT) {
      _enviarBTwitCheck(data2Trama(routine.datosPauseRoutineBT()));
    }
  }

  void _stop() {
    print("Stop");
    setState(() {
      _paused = false;
      _started = false;
      _stopped = true;
      _resumed = false;
      routine.state = 'restarted';
      routine.actualRound = 1;
      routine.actualSet = 1;
    });

    if (routine.isWithBT) {
      _enviarBTwitCheck(data2Trama(routine.datosStopRoutineBT()));
    }
  }

  void _resume() {
    print("Resume");
    setState(() {
      _paused = false;
      _started = false;
      _stopped = false;
      _resumed = true;
    });

    if (routine.isWithBT) {
      _enviarBTwitCheck(data2Trama(routine.datosResumeRoutineBT()));
    }
  }

  void _enviarBTwitCheck(String _trama) {
    enviarBT(_trama).then((_result) {
      print("Resultado del envío  del msj: $_result");
      if (_result == 'target off') {
        _dialogBtFailed(_trama);
      }
    }, onError: (error) {
      print(error);
    });
  }

  void _dialogBtFailed(String _tramaFailedInSent) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Falló la conexión con el Cronómetro"),
        content: Text(
            "Puede intentarlo nuevamente o 'CANCELAR' y continuar el entrenamiento sin conexión Bluetooth"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop("try again");
            },
            child: Text("REENVIAR"),
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
      if (result == "try again") {
        _tryReconnect(_tramaFailedInSent);
      } else {
        //por ahora no hago nada
        print("Decidió continuar entrenando sin Bluetooth");
      }
    });
  }

  void _tryReconnect(String _tramaFailed) async {
    print("Intenta reconectar / resincronizar");
    setState(() {
      _tryReconnecting = true;
    });

    if (isBTConnected()) {
      print("ESTOY CONECTADO AL TARGET");
      // si la conexión se restauró, al presionar "retry" simplemente mandará a resincronizar las rutinas
    } else {
      // si está desconectado, intentará conectarse nuevamente: scan, connect... y luego (al conectarse) mandará a resincronizar
      print(
          "El dispo esta actualmente desconectado, intenta reconectar antes de resincronizar");
      _scanBT();
    }
  }

  _scanBT() {
    setState(() {
      _btLoading = true;
      _connectionText = "Buscando: ${TARGET_DEVICE_NAME}";
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
          _connectionText = "Vinculado a: ${scanResult.device.name}";
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
            child: Text("RECONECTAR"),
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
      _connectionText = "";
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
    print("Manda a cancelar, continuará el training sin BT");
    setState(() {
      _connectionText = "";
      scanResultsList = [];
      _btLoading = false;
      _btVinculated = false;
      _btConnected = false;
      _targetDeviceFound = false;
      _anyDeviceFound = false;
      //routine.isWithBT = false;
    });
  }

  _connectToDevice() async {
    if (targetDevice == null) return;

    setState(() {
      _connectionText = "Device Connecting";
    });

    await targetDevice.connect();
    print('DEVICE CONNECTED');
    setState(() {
      _connectionText = "Device Connected";
    });

    discoverServices();
  }

  _disconnectFromDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();
    print("desconecta");
    setState(() {
      _connectionText = "Device Disconnected";
      deviceState = BluetoothDeviceState.disconnected;
    });
  }

  discoverServices() async {
    if (targetDevice == null) return;
    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            setState(() {
              _connectionText = "All Ready with ${targetDevice.name}";
            });
          }
        });
      }
    });
  }

  //Pruebo agregando estos métodos para resolver el tema de que modificar 'roundIncrement' no me variaba el displayTimer
  // ANDUVO -> Aca accedo a setState de las variables de la rutina, y de finishingInterval
  Widget _RoundsSetsDisplay(
      num _actualRound, num _actualSet, num _totalRounds, num _totalSets) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _RoundOrSetDisplay(_actualRound, _totalRounds, "Round"),
          if (_totalSets > 1) _RoundOrSetDisplay(_actualSet, _totalSets, "Set"),
        ],
      ),
    );
  }

  Widget _RoundOrSetDisplay(num _actual, num _total, String _label) {
    return Column(
      children: <Widget>[
        //Text("${_label}", style: Theme.of(context).textTheme.display1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.skip_previous,
                  color: Colors.grey[600]), //Icon(Icons.exposure_neg_1),
              onPressed: routine.state != "NONE" &&
                      routine.state != 'finished' &&
                      routine.state != 'restarted'
                  ? () {
                      _label == 'Round'
                          ? routine.roundDecrement()
                          : routine.setDecrement();
                    }
                  : null,
              tooltip: _label + " decrement",
            ),
            Text("${_label}",
                style: Theme.of(context).textTheme.display1.copyWith(
                    /*color: Colors.black*/)),
            IconButton(
              icon: Icon(Icons.skip_next, color: Colors.grey[600]),
              onPressed: routine.state != "NONE" &&
                      routine.state != 'finished' &&
                      routine.state != 'restarted'
                  ? () {
                      _label == 'Round'
                          ? routine.roundIncrement()
                          : routine.setIncrement();
                    }
                  : null,
              tooltip: _label + " increment",
            )
          ],
        ),
      ],
    );
  }

  /// After select a 'choice' from PopUpMenu in the AppBar
  _select(Choice _choice) {
    Function _function = _choice.title == 'Disconnect'
        ? () {
            print("Desconectar Bluetooth");
            _disconnectFromDevice();
          }
        : () {
            //print("Resincronizar Bluetooth");
          };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("${_choice.title} Cronómetro"),
        content: Text(
            "Está seguro de que desea ${_choice.title} el Cronómetro Bluetooth?"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop("OK");
            },
            child: Text("OK"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop("CANCEL");
            },
            child: Text("CANCELAR"),
          ),
        ],
      ),
    ).then((result) {
      print(result);
      result == "OK" ? _function() : null;
    });
  }

  Widget _AddSubstractSecondsItem(int _seconds, bool _plus) {
    void _secondsForward(int sec) {
      if (routine.isWithBT) {
        _enviarBTwitCheck(
            data2Trama(routine.datosSecondsForwardRoutineBT(sec)));
      }
    }

    void _secondsBackward(int sec) {
      if (routine.isWithBT) {
        _enviarBTwitCheck(
            data2Trama(routine.datosSecondsBackwardRoutineBT(sec)));
      }
    }

    final String _action = _plus ? "+" : "-";
    return FlatButton(
      onPressed: () {
        routine.state != 'NONE' && routine.state != 'restarted'
            ? _plus ? _secondsForward(_seconds) : _secondsBackward(_seconds)
            : null;
      },
      child: Text(
        _action + " " + _seconds.toString() + "s",
        style: Theme.of(context).textTheme.display1.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold, /*color: Colors.black*/
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.timer,
              color: isBTConnected() ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RoutineDetailsDisplaySimple(
              workTime: routine.workTime,
              restTime: routine.restTime,
              restBtwnSetsTime: routine.restBtwnSetsTime,
            ),
            Divider(thickness: 1),
            Expanded(
              child: GestureDetector(
                onTap: _started || _resumed
                    ? _pause
                    : (_stopped ? _start : _resume),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Icon(
                      _started || _resumed ? Icons.pause : Icons.play_arrow,
                      size: 200,
                      color: Colors.white, //Colors.green[400],
                    ),
                    decoration: BoxDecoration(
                        color: _started || _resumed
                            ? Colors.yellow[600]
                            : Colors
                                .green[400], //Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        //border: Border.all(color: Colors.green[400], width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 10))
                        ]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FloatingActionButton(
                          onPressed: _stopped ? null : _stop,
                          child: Icon(Icons.stop),
                          backgroundColor: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Divider(thickness: 1),
            //Text("Avanzar/Retroceder: ", style: Theme.of(context).textTheme.display1.copyWith(fontSize: 20, color: Colors.black)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _AddSubstractSecondsItem(
                    routine.mode == 'tabata' ? 10 : 60, false),
                _AddSubstractSecondsItem(
                    routine.mode == 'tabata' ? 1 : 10, false),
                _AddSubstractSecondsItem(
                    routine.mode == 'tabata' ? 1 : 10, true),
                _AddSubstractSecondsItem(
                    routine.mode == 'tabata' ? 10 : 60, true),
              ],
            ),
            Divider(thickness: 0.5, height: 4),
            _RoundsSetsDisplay(routine.actualRound, routine.actualSet,
                routine.totalRounds, routine.totalSets),
          ],
        ),
      ),
    );
  }
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Sincronizar', icon: Icons.bluetooth_searching),
  // saco la opción de 'disconnect' -> solo la usaba para debugging
  // intenté, por otro lado, dejarla pero con una variante, que permitiera poner 'Connect' o 'disconnect' de manera que pueda pasar a una rutina con BT o no segun desee en cualquier momento
  // pero no me andaba poner un if(routine.isWithBT) acá
  //const Choice(title: 'Disconnect', icon: Icons.bluetooth_disabled),
];

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
