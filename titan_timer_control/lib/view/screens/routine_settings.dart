import 'package:flutter/material.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/view/widgets/routine_settings/reps_settings.dart';
import 'package:titan_timer_control/view/widgets/routine_settings/time_settings.dart';

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
            Divider(),
            TimeSlider(name: "rest"),
            Divider(),
            TimeSlider(name: "rest-set"),
            Divider(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RepsSetter(name: "round"),
                  RepsSetter(name: "set"),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FlatButton(
                onPressed: () => Navigator.of(context).pushNamed(CONTROL_ROUTE),
                child: Text("Confirmar", style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
