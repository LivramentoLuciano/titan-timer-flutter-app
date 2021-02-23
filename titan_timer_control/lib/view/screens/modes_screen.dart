import 'package:flutter/material.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/view/widgets/modes/mode_tab.dart';

class ModesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _titleStyle = TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Container(
            height: _size.height * 0.45,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 24.0, left: 24, right: 24),
                  child: Text(
                    "Selecciona el modo de entrenamiento",
                    style: _titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(height: 24),
                Column(
                  children: trainingModes
                      .map((_mode) => ModeWidget(mode: _mode))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
