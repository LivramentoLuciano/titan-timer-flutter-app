import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/model/routine.dart';
import 'package:titan_timer_control/view/widgets/control/buttons.dart';
import 'package:titan_timer_control/view/widgets/control/duration_display.dart';
import 'package:titan_timer_control/view/widgets/control/reps_display.dart';

class ControlCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routine = Provider.of<Routine>(context);
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: Card(
        margin: const EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DurationDisplay(name: "work", time: routine.tWork),
                  DurationDisplay(name: "rest", time: routine.tRest),
                  DurationDisplay(name: "rest-set", time: routine.tRestSets),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RepsDisplay(name: "round", value: routine.rounds),
                  RepsDisplay(name: "set", value: routine.rounds),
                ],
              ),
              ControlButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
