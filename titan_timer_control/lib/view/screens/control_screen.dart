import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';
import 'package:titan_timer_control/model/routine.dart';
import 'package:titan_timer_control/view/widgets/bluetooth/show_devices.dart';
import 'package:titan_timer_control/view/widgets/control/background_video.dart';
import 'package:titan_timer_control/view/widgets/control/control.dart';

class ControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cronometroBT = Provider.of<CronometroBluetooth>(context);
    final routine = Provider.of<Routine>(context); // Para que los metodos BT tengan acceso

    _getRoutineSettings() => routine.settings; // lo hice con callback para que BT no requiera la dependencia Routine
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Control", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          SearchBluetooth(
            startNotifySubscription: cronometroBT.startNotifySubscription,
            callbackProcessCommand: cronometroBT.processCommand,
            callbackGetRoutineSettings: _getRoutineSettings,
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
