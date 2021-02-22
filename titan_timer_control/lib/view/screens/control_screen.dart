import 'package:flutter/material.dart';
import 'package:titan_timer_control/view/widgets/control/control.dart';

class ControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Control")),
      body: Stack(
        children: [
          Container(height: size.height, color: Colors.grey[100]),
          Align(
            child: ControlCard(),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}
