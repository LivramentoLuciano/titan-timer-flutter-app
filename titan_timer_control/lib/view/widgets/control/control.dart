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
        margin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DurationDisplay(name: "work", time: routine.tWork),
                  DurationDisplay(name: "rest", time: routine.tRest),
                  if (routine.withSets)
                    DurationDisplay(name: "rest-set", time: routine.tRestSets),
                  if (!routine.withSets)
                    RepsDisplay(name: "round", value: routine.rounds),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (routine.withSets)
                    RepsDisplay(name: "round", value: routine.rounds),
                  if (routine.withSets)
                    RepsDisplay(name: "set", value: routine.sets),
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
