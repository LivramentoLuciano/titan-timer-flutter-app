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
  // Dejo statefull por ahora por el 'appLifeCycle'

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // appcycle
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // // Pido timerState al micro y actualizo el valor en app
        Provider.of<CronometroBluetooth>(context, listen: false)
            .sendRequestTimerState();
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
            startNotifySubscription: cronometroBT.startNotifySubscription,
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
}
