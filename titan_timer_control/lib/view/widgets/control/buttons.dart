import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';
import 'package:titan_timer_control/model/routine.dart';

class ControlButtons extends StatelessWidget {
  final String controlState;
  ControlButtons({this.controlState});

  @override
  Widget build(BuildContext context) {
    final cronometroBT = Provider.of<CronometroBluetooth>(context);
    final routine = Provider.of<Routine>(context);

    final _playIcon = controlState == "started" || controlState == "resumed"
        ? Icon(Icons.pause)
        : Icon(Icons.play_arrow);

    _handlePlayPause() {
      if (controlState == "stopped")
        cronometroBT.sendLoadRoutine(routine.settings);
      else if (controlState == "paused")
        cronometroBT.sendResume();
      else if (controlState == "started" || controlState == "resumed")
        cronometroBT.sendPause();
    }

    // dejo los handler aunque ahora solo envian BT
    // si tuviera timer y round/set actual, deberia actualizarlos aca
    _handleRoundDown() => cronometroBT.sendRoundDown();
    _handleRoundUp() => cronometroBT.sendRoundUp();
    _handleReplay() => cronometroBT.sendReplay();
    _handleForward() => cronometroBT.sendForward();

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              FlatButton(
                onPressed: _handleRoundDown,
                child: Icon(Icons.fast_rewind, color: Colors.black, size: 30),
              ),
              FlatButton(
                onPressed: _handleReplay,
                child: Icon(Icons.replay_10, color: Colors.black, size: 30),
              ),
              FloatingActionButton(
                onPressed: _handlePlayPause,
                child: _playIcon,
              ),
              FlatButton(
                onPressed: _handleForward,
                child: Icon(Icons.forward_10, color: Colors.black, size: 30),
              ),
              FlatButton(
                onPressed: _handleRoundUp,
                child: Icon(Icons.fast_forward, color: Colors.black, size: 30),
              )
            ],
          ),
        ],
      ),
    );
  }
}
