import 'package:flutter/material.dart';
import 'package:titan_timer_control/constants.dart';

class ModesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modos de entrenamiento"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Modes Screen",
              style: TextStyle(fontSize: 24),
            ),
            RaisedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(ROUTINE_SETTINGS_ROUTE),
              child: Text("Sig"),
            )
          ],
        ),
      ),
    );
  }
}
