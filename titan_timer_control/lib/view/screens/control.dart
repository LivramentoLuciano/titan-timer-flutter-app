import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/model/routine.dart';

class ControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routine = Provider.of<Routine>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Control")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Work time: ${mmss(routine.tWork)}"),
            Text("Rest time: ${mmss(routine.tRest)}"),
            Text("Rest-Set time: ${mmss(routine.tRestSets)}"),
            RaisedButton(onPressed: (){}, child: Text("Sig"))
          ],
        ),
      ),
    );
  }
}
