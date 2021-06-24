import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/model/routine.dart';

class ModeWidget extends StatelessWidget {
  ModeWidget({@required this.mode});
  final TrainingMode mode;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final routine = Provider.of<Routine>(context);
    final String _name = mode.name;
    final String _description = mode.description;
    final String _imgURL = mode.imageUrl;

    _handleTapMode() {
      routine.mode = _name;
      routine.defaults(_name); // reemplaza lo que hacia con un Constructor.MODO()...
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
                _name.toUpperCase(),
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
