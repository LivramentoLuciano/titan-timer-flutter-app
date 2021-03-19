import 'package:flutter/material.dart';

class RepsDisplay extends StatelessWidget {
  RepsDisplay({@required this.name, @required this.value});
  final String name;
  final num value;

  @override
  Widget build(BuildContext context) {
    final String _title = name == "round" ? "Rounds" : "Sets";
    final TextStyle _repsStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 24);

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12),
      child: Column(
        children: [
          Text(_title),
          Divider(height: 4),
          Text("$value", style: _repsStyle),
        ],
      ),
    );
  }
}
