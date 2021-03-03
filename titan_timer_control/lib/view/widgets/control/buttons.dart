import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';
import 'package:titan_timer_control/model/routine.dart';

class ControlButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cronometroBT = Provider.of<CronometroBluetooth>(context);
    final routine = Provider.of<Routine>(context);

    final _playIcon = routine.state == RoutineState.STARTED
        ? Icon(Icons.pause)
        : Icon(Icons.play_arrow);

    _handlePlayPause() async {
      if (routine.state == RoutineState.STOPPED) {
        await cronometroBT.sendLoadRoutine(routine.settings);
        await cronometroBT.sendStart();
        // Deberia esperar recibir OK para cambiar 'state'
        routine.state = RoutineState.STARTED;
      } else if (routine.state == RoutineState.PAUSED) {
        await cronometroBT.sendStart();
        routine.state = RoutineState.STARTED;
      } else {
        await cronometroBT.sendPause();
        routine.state = RoutineState.PAUSED;
      }
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
