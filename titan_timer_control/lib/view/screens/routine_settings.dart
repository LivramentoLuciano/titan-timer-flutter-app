import 'package:flutter/material.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/view/widgets/time_slider.dart';

class RoutineSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configuración de tiempos")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimeSlider(name: "work"),
            TimeSlider(name: "rest"),
            TimeSlider(name: "rest-set"),
            RaisedButton(
              onPressed: () => Navigator.of(context).pushNamed(CONTROL_ROUTE),
              child: Text("Sig"),
            )
          ],
        ),
      ),
    );
  }
}
