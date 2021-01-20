import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timer_bt_0/screens/ConfigRoutine.dart';
import 'package:timer_bt_0/widgets/routineModel.dart';
import 'package:timer_bt_0/widgets/TimerDisplayAnimated.dart';
import 'package:timer_bt_0/widgets/routineDetailsDisplay.dart';
import 'package:timer_bt_0/widgets/routineRoundSetDisplay.dart';
import 'package:timer_bt_0/widgets/BT_methods.dart';
import 'package:timer_bt_0/widgets/methods.dart';

import 'package:flutter_blue/flutter_blue.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class RoutinePlay_Screen extends StatefulWidget {
  @override
  _RoutinePlay_ScreenState createState() => _RoutinePlay_ScreenState();
}

class _RoutinePlay_ScreenState extends State<RoutinePlay_Screen> {
  bool _started, _paused, _stopped, _resumed;
  Timer _timer;
  bool _finishingInterval;

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
    routine.timeLeft = routine.initialPrepareTime;
    routine.state = 'NONE';
    _finishingInterval = false;
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
    if (deviceStateSubscription != null){
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
      routine.timeLeft = routine.initialPrepareTime;
      routine.state = 'init';
      routine.actualRound = 1;
      routine.actualSet = 1;
    });
    print("start");

    _timer = Timer.periodic(
      Duration(seconds: 1),
      _timerCallbackFunction,
    );

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
      _timer.cancel();
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
      _timer.cancel();
      routine.timeLeft = routine.initialPrepareTime;
      routine.state = 'restarted';
      routine.actualRound = 1;
      routine.actualSet = 1;
      _finishingInterval = false;
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

    _timer = Timer.periodic(
      Duration(seconds: 1),
      _timerCallbackFunction,
    );

    if (routine.isWithBT) {
      _enviarBTwitCheck(data2Trama(routine.datosResumeRoutineBT()));
    }
  }

  _timerCallbackFunction(Timer t) {
    if (routine.timeLeft <= routine.finishAlarmTime + 1) {
      setState(() {
        _finishingInterval = true;
      });
      if (routine.timeLeft > 1) {
        if (routine.mode != 'combat' ||
            (routine.mode == 'combat' && routine.state == 'init')) {
          playLocalAsset("sounds/beep.mp3");
        }
      }
    } else {
      setState(() {
        _finishingInterval = false;
      });
    }

    if (routine.timeLeft == routine.finishAlarmTime + 1 &&
        routine.mode == 'combat') {
      playLocalAsset("sounds/beep.mp3");
    }

    if (routine.timeLeft == 1) {
      setState(() {
        _finishingInterval = false;
      });
      if (routine.state == 'work') {
        if (routine.actualRound < routine.totalRounds) {
          routine.state = 'rest';
          routine.mode != 'combat'
              ? playLocalAsset("sounds/rest.mp3")
              : playLocalAsset("sounds/campana_box.mp3");
        } else {
          if (routine.actualSet < routine.totalSets) {
            routine.state = 'restBtwnSets';
            playLocalAsset("sounds/rest_between_sets.mp3");
          } else {
            routine.state = 'finished';
            routine.mode != 'combat'
                ? playLocalAsset("sounds/finish.mp3")
                : playLocalAsset("sounds/campana_box.mp3");
            // _initTimer(); //reiniciar todos los valores, dejar listo para reiniciar
            setState(() {
              t.cancel();
              _started = false;
              _paused = false;
              _stopped = true;
              _resumed = false;
            });

            //Cambio para que 'finish' muestre todas las barras de RoundSet llenas
            //el = 1, se hará al presionar 'start' o en un restart en el 'init'
            //this.widget._routine.actualRound = 1;
            //this.widget._routine.actualSet = 1;
          }
        }
      } else {
        if (routine.state == 'rest') {
          routine.actualRound++;
        } else if (routine.state == 'restBtwnSets') {
          routine.actualSet++;
          routine.actualRound = 1;
        } else if (routine.state == 'init') {
          routine.timeLeft = routine.workTime;
        }
        //Todos estos casos siempre terminan pasando a 'work'
        routine.state = 'work';
        routine.mode != 'combat'
            ? playLocalAsset("sounds/work.mp3")
            : playLocalAsset("sounds/fight.mp3");
      }
      // En función del 'state' establezco la duración del timer
      routine.timeLeft = routine.state == 'work' ||
              false //this.widget._routine.state == 'finished'
          ? routine.workTime
          : routine.state == 'rest'
              ? routine.restTime
              : routine.state == 'restBtwnSets'
                  ? routine.restBtwnSetsTime
                  : 0; //'finished' modificado para que quede en '0' al finalizar y no el tiempo Work de nuevo
    } else {
      setState(() {
        routine.timeLeft--;
      });
      //print("TimeLeft: ${toMMSS(routine.timeLeft)}");
    }
  }

  Future<AudioPlayer> playLocalAsset(String audioFile) async {
    AudioCache cache = AudioCache();
    return await cache.play(audioFile);
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
      print("La conexion estaba restaurada - resincroniza directamente");
      //_enviarBTwitCheck(_tramaFailed);
      _resincronizeTimerBT(); //no se si respetará el orden de primero mandarle el comando fallido y dsp resincronizar, por tema de que es todo asincronico 'Future'
      // quizás podria agregarle  + data2Trama(routine.datosResincronizeRoutineBT()) y se enviarían las 2 tramas juntas, pero no tendría el problema de la sincrnía
      // pero creo que el Arduino descartaría la segunda
      // Lo mejor creo que va a ser modificar el progr para que en 'resincronize' se mande si está 'paused', 'started', ... (variable nueva stopwatchControl)
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

            /// En este caso, (por ahora) voy a suponer que solo se conecta en esta screen cuando es un intento de resincronizacion
            /// o un msj fallido por desconexión, que derivará en una resincronización
            _resincronizeTimerBT();
          }
        });
      }
    });
  }

  _resincronizeTimerBT() {
    print(
        "Manda a RESINCRONIZAR, por haberse apagado el TimerBT, o desconectado o ambas");
    print(
        "Puede provenir de un intento de 'PAUSE', 'STOP'... que queda trunco, por la falla en la conexión");
    print("O porque el usuario observa que el Timer BT se apagó o desconectó");
    //_enviarBT("RESINCRONIZAR: X; 1234;567;890;12;12");
    //por ahora, lo uso mientras debuggeo un toque, para tener un botón que desconecte el BT
    //_disconnectFromDevice();
    // Agrego que pause el timer si es una 'resincronización' para no tener que mandar el stopwatchControl (_paused, _resumed...)
    // De esta manera forzo a que en resincronia se pause el stopwatch, es como llamar a un 'pause' pero no lo hago por el tema de que adentro tengo el envio del msj bluetooth y no voy a modificar eso tmb ahora
    // Tener en cuenta esto y forzar el 'pause' en el Arduino en el código
    if (_started || _resumed) {
      setState(() {
        _paused = true;
        _started = false;
        _stopped = false;
        _resumed = false;
        _timer.cancel();
      });
    }
    _enviarBTwitCheck(data2Trama(routine.datosResincronizeRoutineBT()));
  }

  //Pruebo agregando estos métodos para resolver el tema de que modificar 'roundIncrement' no me variaba el displayTimer
  // ANDUVO -> Aca accedo a setState de las variables de la rutina, y de finishingInterval
  Widget _RoundsSetsDisplay(
      num _actualRound, num _actualSet, num _totalRounds, num _totalSets) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: _RoundOrSetDisplay(_actualRound, _totalRounds, "Round")),
          Visibility(
            visible: _totalSets > 1,
            child: Expanded(
                child: _RoundOrSetDisplay(_actualSet, _totalSets, "Set")),
          )
        ],
      ),
    );
  }

  Widget _RoundOrSetDisplay(num _actual, num _total, String _label) {
    return Column(
      children: <Widget>[
        Text(_label, style: Theme.of(context).textTheme.display1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.skip_previous), //Icon(Icons.exposure_neg_1),
                onPressed: routine.state == "work" ||
                        routine.state == "rest" ||
                        routine.state == "restBtwnSets"
                    ? () {
                        // Prueba para ver de que se pause el reloj al cambiar de round,
                        // y una vez cambiado, que cuente 1 segundo por completo, antes de dispararse la funcion del timer callback
                        // Aparentemente anduvo bien, tanto app como arduino esperan 1 segundo completo  al cambiar de round
                        // ver si el objeto Timer se podría poner dentro del routineModel, lo que me permitiría controlarlo desde sus métodos
                        if (_started || _resumed) _timer.cancel();
                        if (_label == 'Round') {
                          routine.roundDecrement();
                        } else {
                          routine.setDecrement();
                        }
                        if (_started || _resumed) {
                          //para que no lo inicie si estaba en 'pausa' antes de incrementar el round
                          _timer = Timer.periodic(
                            Duration(seconds: 1),
                            _timerCallbackFunction,
                          );
                        }
                        setState(() {
                          /*this.widget._routine.timeLeft = routine.timeLeft;
                          this.widget._routine.state = routine.state;
                          this.widget._routine.actualRound =
                              routine.actualRound;
                          this.widget._routine.actualSet = routine.actualSet;*/
                          this._finishingInterval = false;
                        });
                      }
                    : null),
            Text(
              "${_actual} / ${_total}",
              style: Theme.of(context).textTheme.display1,
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: routine.state == "work" ||
                      routine.state == "rest" ||
                      routine.state == "restBtwnSets"
                  ? () {
                      if (_started || _resumed) _timer.cancel();
                      if (_label == 'Round') {
                        routine.roundIncrement();
                      } else {
                        routine.setIncrement();
                      }
                      if (_started || _resumed) {
                        _timer = Timer.periodic(
                          Duration(seconds: 1),
                          _timerCallbackFunction,
                        );
                      }
                      setState(() {
                        /* Por el cambio de separar Screens (BT_Config y StopwatchView)
                        this.widget._routine.timeLeft = routine.timeLeft;
                        this.widget._routine.state = routine.state;
                        this.widget._routine.actualRound = routine.actualRound;
                        this.widget._routine.actualSet = routine.actualSet;*/
                        this._finishingInterval = false;
                      });
                    }
                  : null,
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
            print("Resincronizar Bluetooth");
            _resincronizeTimerBT();
          };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("${_choice.title} Cronómetro"),
        content:
            Text("Está seguro de que desea ${_choice.title} el Cronómetro Bluetooth?"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer"),
        centerTitle: true,
        actions: routine.isWithBT
            ? <Widget>[
                PopupMenuButton<Choice>(
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuEntry> _listEntry = [];
                    _listEntry = choices.skip(0).map((Choice choice) {
                      return PopupMenuItem<Choice>(
                        value: choice,
                        child: Text(choice.title),
                      );
                    }).toList();
                    return _listEntry;
                  },
                  icon: Icon(Icons.timer, color: isBTConnected()? Colors.green : Colors.red,),
                  //icon: Icon(Icons.bluetooth, color: isBTConnected()? Colors.green : Colors.red,),
                  onSelected: _select,
                )
              ]
            : null,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RoutineDetailsDisplaySimple(
              workTime: routine.workTime,
              restTime: routine.restTime,
              restBtwnSetsTime: routine.restBtwnSetsTime,
              /*
            workTime: this.widget._routine.workTime,...*/
            ),
            Divider(thickness: 1),
            Expanded(
              child: GestureDetector(
                onTap: _started || _resumed
                    ? _pause
                    : (_stopped ? _start : _resume),
                child: TimerDisplayAnimated_stateless(
                  timeLeft: routine.timeLeft,
                  routineState: routine.state, //this.widget._routine.state,
                  started: _started,
                  stopped: _stopped,
                  resumed: _resumed,
                  paused: _paused,
                  finishing: _finishingInterval,
                ),
              ),
            ),
            _RoundsSetsDisplay(routine.actualRound, routine.actualSet,
                routine.totalRounds, routine.totalSets
                // Por el cambio de separar en screens (BT_Config y StopwatchView)
                /*this.widget._routine.actualRound, ....*/
                ),
            /*RoundsSetsDisplay(
            actualRound: this.widget._routine.actualRound,...),*/
            Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          onPressed: _stopped ? null : _stop,
                          label: Text("Reset"),
                          backgroundColor: Colors.redAccent,
                        ),
                        // lo saco por aspecto visual con respecto al botón de resincronizar
                        if (true /*!routine.isWithBT*/)
                          FloatingActionButton.extended(
                            heroTag: null,
                            onPressed: _started || _resumed
                                ? _pause
                                : (_stopped ? _start : _resume),
                            label: Text(
                              _started || _resumed
                                  ? "Pause"
                                  : _paused ? "Continue" : "Start",
                              style: TextStyle(
                                color: _started || _resumed
                                    ? Colors.yellow[800]
                                    : Colors.white,
                              ),
                            ),
                            backgroundColor: _started || _resumed
                                ? Colors.white
                                : Colors.green[400],
                          ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: false, // routine.isWithBT,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: _resincronizeTimerBT,
                          child: Icon(
                            Icons.settings_bluetooth,
                            size: 20,
                          ),
                          tooltip: "Sincronize Bluetooth Timer",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Saco lo sig, era para tener una barra abajo (o Sliding Up Panel) del estado Bluetooth
            Visibility(
              visible: false, //_tryReconnecting, // routine.isWithBT,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white10, //color: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    _connectionText,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
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
