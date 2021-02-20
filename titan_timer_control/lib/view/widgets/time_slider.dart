import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/model/routine.dart';

class TimeSlider extends StatelessWidget {
  final String name;
  TimeSlider({this.name});

  @override
  Widget build(BuildContext context) {
    // uso Provider de Routine para poder acceder a la misma sin pasajes de parametros
    final routine = Provider.of<Routine>(context);
    final num _time = name == "work"
        ? routine.tWork
        : name == "rest"
            ? routine.tRest
            : routine.tRestSets;
    
    final String _title = name == "work"
        ? "Trabajo:"
        : name == "rest"
            ? "Recuperación:"
            : "Descanso entre sets:";

    _handleNewValue(newValue) {
      if (name == "work")
        routine.tWork = newValue;
      else if (name == "rest")
        routine.tRest = newValue;
      else
        routine.tRestSets = newValue;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_title, style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(mmss(_time), style: Theme.of(context).textTheme.headline4),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.grey[200],
              ),
              child: Slider(
                min: 0,
                max: 400,
                value: _time.toDouble(),
                onChanged: _handleNewValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
