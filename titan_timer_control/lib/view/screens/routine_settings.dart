import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/model/routine.dart';
import 'package:titan_timer_control/view/screens/control.dart';
import 'package:titan_timer_control/view/widgets/time_slider.dart';

class RoutineSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Routine>(
      create: (_) => Routine(tWork: 10, tRest: 10, tRestSets: 30),
      child: Scaffold(
        appBar: AppBar(title: Text("Configuración de tiempos")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimeSlider(name: "work"),
              Divider(thickness: 1),
              TimeSlider(name: "rest"),
              Divider(thickness: 1),
              TimeSlider(name: "rest-set"),
              Divider(thickness: 1),
              _ConfirmButton()
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routine = Provider.of<Routine>(context);

    return RaisedButton(
      // onPressed: () => Navigator.of(context).pushNamed(CONTROL_ROUTE),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider<Routine>(
              create: (context) => routine,
              child: ControlScreen(),
            );
          },
        ),
      ),
      child: Text("Sig"),
    );
  }
}
