/// UPDATE: NO SE USA
/// Por cambios en el widget de routinePlay (se reemplazó esto con un método en dicha screen
/// por necesidad de acceso al state del mismo)

import 'package:flutter/material.dart';
import 'package:timer_bt_0/screens/ConfigRoutine.dart';

class RoundsSetsDisplay extends StatelessWidget {
  const RoundsSetsDisplay({
    Key key,
    @required this.actualRound,
    @required this.totalRounds,
    @required this.actualSet,
    @required this.totalSets,
  }) : super(key: key);

  final int actualRound, totalRounds, actualSet, totalSets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RoundOrSetDisplay(
                label: "Round", actual: actualRound, total: totalRounds),

            /// Aparentemente, ANDA, acceso al 'routine' del fichero Config sin necesidad de pasarlo como parámetro
            //label: "Round", actual: routine.actualRound, total: totalRounds),
          ),
          Visibility(
            visible: totalSets > 1,
            child: Expanded(
              child: RoundOrSetDisplay(
                  label: "Set", actual: actualSet, total: totalSets),
            ),
          )
        ],
      ),
    );
  }
}

class RoundOrSetDisplay extends StatelessWidget {
  const RoundOrSetDisplay({
    Key key,
    @required this.actual,
    @required this.total,
    @required this.label,
  }) : super(key: key);

  final int actual;
  final int total;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          this.label,
          style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white), //TextStyle(fontSize: 30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.skip_previous), //Icon(Icons.exposure_neg_1),
                onPressed: routine.state == "work" ||
                        routine.state == "rest" ||
                        routine.state == "restBtwnSets"
                    ? () {
                        label == 'Round'
                            ? routine.roundDecrement()
                            : routine.setDecrement();
                      }
                    : null),
            Text(
              "${this.actual} / ${this.total}",
              style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white), //TextStyle(fontSize: 30),
            ),
            IconButton(
              icon: Icon(Icons.skip_next), //Icon(Icons.exposure_plus_1),
              onPressed: routine.state == "work" ||
                      routine.state == "rest" ||
                      routine.state == "restBtwnSets"
                  ? () {
                      label == 'Round'
                          ? routine.roundIncrement()
                          : routine.setIncrement();
                    }
                  : null,
            )
            //repeat_one, plus_one
            //minimize, navigation_before, arrow_left
            //refresh, replay, rotate_right,left, skip_next, previous
          ],
        ),
      ],
    );
  }
}