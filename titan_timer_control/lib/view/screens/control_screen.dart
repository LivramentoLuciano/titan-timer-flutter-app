import 'package:flutter/material.dart';
import 'package:titan_timer_control/view/widgets/bluetooth/connect_bt.dart';
import 'package:titan_timer_control/view/widgets/control/background_video.dart';
import 'package:titan_timer_control/view/widgets/control/control.dart';


class ControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Control", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [BtDevicesWidget()],
      ),
      body: Stack(
        children: [
          BackgroundVideo(),
          Align(child: ControlCard(), alignment: Alignment.bottomCenter),
        ],
      ),
    );
  }
}