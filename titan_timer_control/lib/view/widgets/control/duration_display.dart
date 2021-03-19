import 'package:flutter/material.dart';
import 'package:titan_timer_control/constants.dart';

class DurationDisplay extends StatelessWidget {
  const DurationDisplay({Key key, @required this.time, @required this.name})
      : super(key: key);

  final num time;
  final String name;

  @override
  Widget build(BuildContext context) {
    final String title = name == "work"
        ? "Trabajo"
        : name == "rest"
            ? "Recuperación"
            : "Descanso";

    final TextStyle timeStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 24);

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12),
      child: Column(
        children: [
          Text("$title"),
          Divider(height: 4),
          Text("${mmss(time)}", style: timeStyle),
        ],
      ),
    );
  }
}
