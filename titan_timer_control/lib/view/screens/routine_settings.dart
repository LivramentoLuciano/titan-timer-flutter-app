import 'package:flutter/material.dart';
import 'package:titan_timer_control/constants.dart';

class RoutineSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configuración de la rutina")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Settings Screen"),
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
