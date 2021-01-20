/// UPDATE: NO SE USA
/// Por cambios del programa no uso este widget, el mismo está en 'RoutinePlay.dart' screen

import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:timer_bt_0/screens/ConfigRoutine.dart';
import 'package:timer_bt_0/widgets/TimerDisplayAnimated.dart';
import 'package:timer_bt_0/widgets/routineDetailsDisplay.dart';
import 'package:timer_bt_0/widgets/routineModel.dart';
import 'package:timer_bt_0/widgets/routineRoundSetDisplay.dart';
import 'package:timer_bt_0/widgets/BT_methods.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert' show utf8;

class StopwatchView extends StatefulWidget {
  const StopwatchView({
    Key key,
    @required Routine routine,
  })  : _routine = routine,
        super(key: key);

  final Routine _routine;

  @override
  _StopwatchViewState createState() => _StopwatchViewState();
}

class _StopwatchViewState extends State<StopwatchView> {
  bool _started, _paused, _stopped, _resumed;
  Timer _timer;
  bool _finishingInterval;

  String _connectionText, _connectDisconnectText;

  String tramaBT;

  @override
  void initState() {
    _started = false;
    _paused = false;
    _stopped = true;
    _resumed = false;
    this.widget._routine.timeLeft = this.widget._routine.initialPrepareTime;
    this.widget._routine.state = 'NONE';
    _finishingInterval = false;
    _connectionText =
        routine.isWithBT ? "Vinculado a ${targetDevice.name}" : "NONE";
    scanResultsList = [];
    _connectDisconnectText = "Disconnect";
    super.initState();
  }

  void _start() {
    setState(() {
      _started = true;
      _paused = false;
      _stopped = false;
      _resumed = false;
      routine.timeLeft = this.widget._routine.initialPrepareTime;
      this.widget._routine.state = 'init';
      this.widget._routine.actualRound = 1;
      this.widget._routine.actualSet = 1;
    });
    print("start");

    _timer = Timer.periodic(
      Duration(seconds: 1),
      _timerCallbackFunction,
    );

    if (routine.isWithBT) {
      enviarBT(data2Trama(routine.datosStartRoutineBT()));
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
      enviarBT(data2Trama(routine.datosPauseRoutineBT()));
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
      routine.timeLeft = this.widget._routine.initialPrepareTime;
      this.widget._routine.state = 'restarted';
      this.widget._routine.actualRound = 1;
      this.widget._routine.actualSet = 1;
      _finishingInterval = false;
    });

    if (routine.isWithBT) {
      enviarBT(data2Trama(routine.datosStopRoutineBT()));
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
      enviarBT(data2Trama(routine.datosResumeRoutineBT()));
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
      if (this.widget._routine.state == 'work') {
        if (this.widget._routine.actualRound <
            this.widget._routine.totalRounds) {
          this.widget._routine.state = 'rest';
          this.widget._routine.mode != 'combat'
              ? playLocalAsset("sounds/rest.mp3")
              : playLocalAsset("sounds/campana_box.mp3");
        } else {
          if (this.widget._routine.actualSet < this.widget._routine.totalSets) {
            this.widget._routine.state = 'restBtwnSets';
            playLocalAsset("sounds/rest_between_sets.mp3");
          } else {
            this.widget._routine.state = 'finished';
            this.widget._routine.mode != 'combat'
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
        if (this.widget._routine.state == 'rest') {
          this.widget._routine.actualRound++;
        } else if (this.widget._routine.state == 'restBtwnSets') {
          this.widget._routine.actualSet++;
          this.widget._routine.actualRound = 1;
        } else if (this.widget._routine.state == 'init') {
          routine.timeLeft = this.widget._routine.workTime;
        }
        //Todos estos casos siempre terminan pasando a 'work'
        this.widget._routine.state = 'work';
        this.widget._routine.mode != 'combat'
            ? playLocalAsset("sounds/work.mp3")
            : playLocalAsset("sounds/fight.mp3");
      }
      // En función del 'state' establezco la duración del timer
      this.widget._routine.timeLeft = this.widget._routine.state == 'work' ||
              false //this.widget._routine.state == 'finished'
          ? this.widget._routine.workTime
          : this.widget._routine.state == 'rest'
              ? this.widget._routine.restTime
              : this.widget._routine.state == 'restBtwnSets'
                  ? this.widget._routine.restBtwnSetsTime
                  : 0; //'finished' modificado para que quede en '0' al finalizar y no el tiempo Work de nuevo
    } else {
      setState(() {
        routine.timeLeft--;
      });
    }
  }

  Future<AudioPlayer> playLocalAsset(String audioFile) async {
    AudioCache cache = AudioCache();
    return await cache.play(audioFile);
  }

  _scanBT() {
    setState(() {
      _connectionText = "Start Scanning";
      //scanResultsList = []; //probando, reinicio el Scan (limpio la lista de dispos)
    });

    scanSubScription = flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name != null && scanResult.device.name != "")
        setState(() {
          scanResultsList.add(scanResult.device);
        });
      if (scanResult.device.name == TARGET_DEVICE_NAME) {
        //scanResultsList.add(scanResult.device.name);
        //print(scanResult.device);
        print('DEVICE found');
        _stopScan();
        setState(() {
          _connectionText = "Found Target Device";
        });

        targetDevice = scanResult.device;
        _connectToDevice();
      }
    }, onDone: () => _stopScan());
  }

  _stopScan() {
    print("STOPING SCAN");
    scanResultsList
        .forEach((device) => print("Nombre Dispositivo: ${device.name}"));
    flutterBlue.stopScan();
    scanSubScription?.cancel();
    //scanSubScription.cancel();
    scanSubScription = null;
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
      _connectDisconnectText = "Disconnect";
    });

    discoverServices();
  }

  _disconnectFromDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();
    print("desconecta");
    setState(() {
      _connectionText = "Device Disconnected";
      _connectDisconnectText = "Connect to";
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

  _resincronizeTimerBT() {
    print(
        "Manda a RESINCRONIZAR, por haberse apagado el TimerBT, o desconectado o ambas");
    print(
        "Puede provenir de un intento de 'PAUSE', 'STOP'... que queda trunco, por la falla en la conexión");
    print("O porque el usuario observa que el Timer BT se apagó o desconectó");
    //_enviarBT("RESINCRONIZAR: X; 1234;567;890;12;12");
    //por ahora, lo uso mientras debuggeo un toque, para tener un botón que desconecte el BT
    _disconnectFromDevice();
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
              child: _RoundOrSetDisplay(_actualRound, _totalRounds, "Round")

              /// Aparentemente, ANDA, acceso al 'routine' del fichero Config sin necesidad de pasarlo como parámetro
              //label: "Round", actual: routine.actualRound, total: totalRounds),
              ),
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
                          this.widget._routine.timeLeft = routine.timeLeft;
                          this.widget._routine.state = routine.state;
                          this.widget._routine.actualRound =
                              routine.actualRound;
                          this.widget._routine.actualSet = routine.actualSet;
                          this._finishingInterval = false;
                        });
                      }
                    : null),
            Text(
              "${_actual} / ${_total}",
              style: Theme.of(context).textTheme.display1,
            ),
            IconButton(
              icon: Icon(Icons.skip_next), //Icon(Icons.exposure_plus_1),
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
                        this.widget._routine.timeLeft = routine.timeLeft;
                        this.widget._routine.state = routine.state;
                        this.widget._routine.actualRound = routine.actualRound;
                        this.widget._routine.actualSet = routine.actualSet;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RoutineDetailsDisplaySimple(
            workTime: this.widget._routine.workTime,
            restTime: this.widget._routine.restTime,
            restBtwnSetsTime: this.widget._routine.restBtwnSetsTime,
          ),
          Divider(thickness: 1),
          Expanded(
            child: GestureDetector(
              onTap:
                  _started || _resumed ? _pause : (_stopped ? _start : _resume),
              child: TimerDisplayAnimated_stateless(
                timeLeft: routine.timeLeft,
                routineState: this.widget._routine.state,
                started: _started,
                stopped: _stopped,
                resumed: _resumed,
                paused: _paused,
                finishing: _finishingInterval,
              ),
            ),
          ),
          _RoundsSetsDisplay(
            this.widget._routine.actualRound,
            this.widget._routine.actualSet,
            this.widget._routine.totalRounds,
            this.widget._routine.totalSets,
          ),
          /*RoundsSetsDisplay(
            actualRound: this.widget._routine.actualRound,
            actualSet: this.widget._routine.actualSet,
            totalRounds: this.widget._routine.totalRounds,
            totalSets: this.widget._routine.totalSets,
          ),*/
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
                      if (!routine.isWithBT)
                        FloatingActionButton.extended(
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
                  visible: routine.isWithBT,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FloatingActionButton(
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
          /*Visibility(
            visible: false, // routine.isWithBT,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white10, //color: Theme.of(context).accentColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _connectionText,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    FlatButton(
                      onPressed:
                          () {}, //_toogleConnectionFromDevice, //_disconnectFromDevice, //toogleConnection
                      child: Text(_connectDisconnectText),
                    )
                    /*Switch(
                      value: true,
                      onChanged: (value) {},
                    )*/
                  ],
                ),
              ),
            ),
          )*/
        ],
      ),
    );
  }
}
