import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';
import 'package:titan_timer_control/view/widgets/bluetooth/show_devices.dart';
import 'package:titan_timer_control/view/widgets/control/background_video.dart';
import 'package:titan_timer_control/view/widgets/control/control.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen>
    with WidgetsBindingObserver {

  // Recepcion de mensajes - No logre cancelarla si lo uso en Provider
  StreamSubscription<List<int>> _notifySubscription;
  var _cronometroBT;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // appcycle
    _cronometroBT = Provider.of<CronometroBluetooth>(context, listen: false);
    _cronometroBT.timerState = "stopped"; 
    // Si esta conectado reinicio la notifySubscription, sino, lo hace al conectar
    if (_cronometroBT.targetDevice != null)
      _startNotifySubscription(_cronometroBT, _cronometroBT.processCommand);
    super.initState();
  }

  @override
  void dispose() {
    // Cancelo el stream, porque sino queda asociado a este widget (por el setState)
    // Provider.of<CronometroBluetooth>(context, listen: false).cancelNotifySubscription(); // no logro que ande este
    _cancelNotifySubscription();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // print("Al volver a foreground el estado estaba: $_controlState");
        // // Pido timerState al micro y actualizo el valor en app
        _cronometroBT.sendRequestTimerState();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final cronometroBT =
        Provider.of<CronometroBluetooth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Control", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          SearchBluetooth(
            startNotifySubscription: _startNotifySubscription,
            callbackProcessCommand: cronometroBT.processCommand,
          )
        ],
      ),
      body: Stack(
        children: [
          BackgroundVideo(),
          Align(
            child: ControlCard(),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }

  void _startNotifySubscription(
    CronometroBluetooth _cronometroBT,
    Function processCommand,
  ) async {
    await _cronometroBT.targetCharacteristics.setNotifyValue(true);

    _notifySubscription = _cronometroBT.targetCharacteristics.value.listen(
      (_value) {
        final _data = utf8.decode(_value);
        final _trama = _cronometroBT.getTrama(_data);
        print("Data recibida: $_data");

        if (_trama != null) processCommand(_trama);
      },
    );
  }

  _cancelNotifySubscription() async =>
      (_notifySubscription != null) ? await _notifySubscription.cancel() : null;
}
