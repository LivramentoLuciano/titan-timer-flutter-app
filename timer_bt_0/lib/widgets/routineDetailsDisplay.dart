import 'package:flutter/material.dart';
import 'package:timer_bt_0/screens/ConfigRoutine.dart';

import 'methods.dart';

class RoutineDetailsDisplay extends StatelessWidget {
  const RoutineDetailsDisplay({
    Key key,
    @required this.workTime,
    @required this.restTime,
    @required this.restBtwnSetsTime,
  }) : super(key: key);

  final workTime, restTime, restBtwnSetsTime;

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = Theme.of(context).textTheme.headline;

    return Container(
      //color: Colors.black,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /*Align(
                alignment: Alignment.centerLeft,
                child: Text("Detalles rutina:",
                    style: TextStyle(fontSize: 24, color: Colors.white))),*/
            Text("Work: " + toMMSS(workTime), style: _textStyle),
            Text("Rest: " + toMMSS(restTime), style: _textStyle),
            Text("Rest between sets: " + toMMSS(restBtwnSetsTime),
                style: _textStyle),
          ],
        ),
      ),
    );
  }
}

class RoutineDetailsDisplaySimple extends StatelessWidget {
  final workTime, restTime, restBtwnSetsTime;
  const RoutineDetailsDisplaySimple({
    Key key,
    @required this.workTime,
    @required this.restTime,
    @required this.restBtwnSetsTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 4),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DetailsRowElement(
                    time: this.workTime, icon: Icons.directions_run),
                DetailsRowElement(
                    time: this.restTime,
                    icon: routine.mode == 'tabata'
                        ? Icons.accessibility
                        : Icons.cached),
                if (routine.mode == 'tabata')
                  DetailsRowElement(
                      time: this.restBtwnSetsTime, icon: Icons.cached),
              ],
            ),
            Divider(thickness: 0.5, height: 16,),
            if (true) //para prueba de App simple sin Timer, SOLO CONTROL BLUETOOTH, pongo totalSet y totalRounds acá
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RoundsSetsRowElement(
                        label: 'Rounds', numberOf: routine.totalRounds),
                    if (routine.totalSets > 1)
                      RoundsSetsRowElement(
                          label: 'Sets', numberOf: routine.totalSets)
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RoundsSetsRowElement extends StatelessWidget {
  final String label;
  final int numberOf;
  const RoundsSetsRowElement({
    Key key,
    @required this.label,
    @required this.numberOf,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = Theme.of(context)
        .textTheme
        .headline
        .copyWith(fontSize: 28, fontWeight: FontWeight.normal);
    return Text("${label}: ${numberOf}", style: _textStyle,);
  }
}

class DetailsRowElement extends StatelessWidget {
  const DetailsRowElement({
    Key key,
    @required this.time,
    @required this.icon,
  }) : super(key: key);

  final int time;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = Theme.of(context)
        .textTheme
        .headline
        .copyWith(fontSize: 28, fontWeight: FontWeight.normal);
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(this.icon),
        SizedBox(
          width: 5,
        ),
        Text(toMMSS(this.time), style: _textStyle)
      ],
    );
  }
}
