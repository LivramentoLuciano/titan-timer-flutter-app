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

    Map<String, dynamic> _properties() {
      Map<String, dynamic> v;
      if (name == "work") {
        v = {
          "time": routine.tWork,
          "title": "Trabajo:",
          "maxT": routine.max_tWork,
          "minT": routine.min_tWork
        };
      } else if (name == "rest") {
        v = {
          "time": routine.tRest,
          "title": "Preparación:",
          "maxT": routine.max_tRest,
          "minT": routine.min_tRest
        };
      } else {
        v = {
          "time": routine.tRestSets,
          "title": "Descanso:",
          "maxT": routine.max_tRestSets,
          "minT": routine.min_tRestSets
        };
      }
      return v;
    }

    _handleNewValue(newValue) {
      // Le doy pasos al slider (No sube de a 1 segundo)
      double _discretizo(double value){
        final _paso = routine.mode == "amrap" || routine.mode == "combat" ? 30 : 2;
        final _valueD = ((value.toInt() ~/ _paso) * _paso).toDouble();
        if (_valueD < _properties()["minT"]) return _properties()["minT"].toDouble();
        if (_valueD > _properties()["maxT"]) return _properties()["maxT"].toDouble();
        return _valueD;
      }

      newValue = _discretizo(newValue);
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
            Text(_properties()["title"], style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(mmss(_properties()["time"]),
                  style: Theme.of(context).textTheme.headline4),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.grey[200],
              ),
              child: Slider(
                min: _properties()["minT"].toDouble(),
                max: _properties()["maxT"].toDouble(),
                value: _properties()["time"].toDouble(),
                onChanged: _handleNewValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
