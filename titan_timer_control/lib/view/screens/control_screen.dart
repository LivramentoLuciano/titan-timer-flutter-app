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

class _ControlScreenState extends State<ControlScreen> {
  String _controlState; // recibe desde Bluetooth

  @override
  void initState() {
    _controlState = "stopped";
    super.initState();
  }

  void setControlState(String s) => setState(() => _controlState = s);

  @override
  Widget build(BuildContext context) {
    final cronometroBT = Provider.of<CronometroBluetooth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Control", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          SearchBluetooth(
            startNotifySubscription: cronometroBT.startNotifySubscription,
            callbackProcessCommand: cronometroBT.processCommand,
            callbackSetControlState: setControlState,
          )
        ],
      ),
      body: Stack(
        children: [
          BackgroundVideo(),
          Align(
            child: ControlCard(controlState: _controlState),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}
