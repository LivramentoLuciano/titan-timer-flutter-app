import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/model/routine.dart';

class RepsSetter extends StatelessWidget {
  RepsSetter({@required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final routine = Provider.of<Routine>(context);
    final _title = name == "round" ? "Rounds:" : "Sets:";
    final _reps = name == "round" ? routine.rounds : routine.sets;

    final _iconColor = Theme.of(context).accentColor;

    _handleMinus() {
      if (name == "round") {
        if (routine.rounds > 1) routine.rounds--;
      } else if (name == "set") {
        if (routine.sets > 1) routine.sets--;
      }
    }

    _handlePlus() {
      if (name == "round") {
        if (routine.rounds < routine.maxRounds) routine.rounds++;
      } else if (name == "set") {
        if (routine.sets < routine.maxSets) routine.sets++;
      }
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_title, style: TextStyle(fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _handleMinus,
                icon: Icon(Icons.remove_circle, color: _iconColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text("$_reps",
                    style: Theme.of(context).textTheme.headline4),
              ),
              IconButton(
                onPressed: _handlePlus,
                icon: Icon(Icons.add_circle, color: _iconColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
