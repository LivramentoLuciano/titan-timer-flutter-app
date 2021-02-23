import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/model/routine.dart';

class ModeTab extends StatelessWidget {
  ModeTab({@required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final routine = Provider.of<Routine>(context);
    final String _description = trainingModes[name]["description"];
    final String _imgURL = trainingModes[name]["img-icon"];

    _handleTapMode() {
      routine.mode = name;
      routine.defaults(name); // reemplaza lo que hacia con un Constructor.MODO()...
      Navigator.of(context).pushNamed(ROUTINE_SETTINGS_ROUTE);
    }

    return SizedBox(
      width: _size.width,
      height: 160,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: _handleTapMode,
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 12, bottom: 24),
            child: ListTile(
              title: Text(
                name.toUpperCase(),
                style: TextStyle(fontSize: 24),
              ),
              subtitle: Text(_description),
              trailing: CircleAvatar(
                backgroundImage: AssetImage(_imgURL),
                radius: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
