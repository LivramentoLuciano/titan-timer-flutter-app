import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/model/routine.dart';
import 'package:titan_timer_control/view/widgets/routine_settings/reps_settings.dart';
import 'package:titan_timer_control/view/widgets/routine_settings/time_settings.dart';

class RoutineSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routine = Provider.of<Routine>(context);

    bool _withSets() => (routine.mode != "amrap" && routine.mode != "combate");

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
            if (_withSets()) TimeSlider(name: "rest-set"),
            if (_withSets()) Divider(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RepsSetter(name: "round"),
                  if (_withSets()) RepsSetter(name: "set"),
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
