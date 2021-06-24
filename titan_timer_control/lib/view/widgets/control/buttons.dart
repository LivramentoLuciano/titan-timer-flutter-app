import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';
import 'package:titan_timer_control/model/routine.dart';

class ControlButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cronometroBT = Provider.of<CronometroBluetooth>(context);
    final routine = Provider.of<Routine>(context);
    final _timerState = cronometroBT.timerState;

    final _playIcon = _timerState == "started" || _timerState == "resumed"
        ? Icon(Icons.pause)
        : Icon(Icons.play_arrow);

    final Icon _secondsReplayIcon = routine.deltaSeconds == 30
        ? Icon(Icons.replay_30, size: 30, color: Colors.black)
        : routine.deltaSeconds == 5
            ? Icon(Icons.replay_5, size: 30, color: Colors.black)
            : Icon(Icons.replay_5, size: 30);

    final Icon _secondsForwardIcon = routine.deltaSeconds == 30
        ? Icon(Icons.forward_30, size: 30, color: Colors.black)
        : routine.deltaSeconds == 5
            ? Icon(Icons.forward_5, size: 30, color: Colors.black)
            : Icon(Icons.forward_5, size: 30);

    final Icon _roundDownIcon =
        Icon(Icons.fast_rewind, color: Colors.black, size: 30);

    final Icon _roundUpIcon =
        Icon(Icons.fast_forward, color: Colors.black, size: 30);

    _handlePlayPause() {
      if (_timerState == "stopped")
        cronometroBT.sendLoadRoutine(routine.settings);
      else if (_timerState == "paused")
        cronometroBT.sendResume();
      else if (_timerState == "started" || _timerState == "resumed")
        cronometroBT.sendPause();
    }

    // dejo los handler aunque ahora solo envian BT
    // si tuviera timer y round/set actual, deberia actualizarlos aca
    _handleRoundDown() => cronometroBT.sendRoundDown();
    _handleRoundUp() => cronometroBT.sendRoundUp();

    _handleReplay() => cronometroBT.sendReplay(routine);
    _handleForward() => cronometroBT.sendForward(routine);

    // Boton personalizado -> InkWell + Padding 
    // Correcta UI incluso en Celu xs
    Widget ControlButton({Function handler, Icon icon}) {
      return (handler == _handleRoundDown || handler == _handleRoundUp)
          ? InkWell(
              onTap: handler,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: icon,
              ),
            )
          : InkWell(
              onTap: routine.tWork > 40 ? handler : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: icon,
              ),
            );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          ControlButton(handler: _handleRoundDown, icon: _roundDownIcon),
          ControlButton(handler: _handleReplay, icon: _secondsReplayIcon),
          FloatingActionButton(onPressed: _handlePlayPause, child: _playIcon),
          ControlButton(handler: _handleForward, icon: _secondsForwardIcon),
          ControlButton(handler: _handleRoundUp, icon: _roundUpIcon)
        ],
      ),
    );
  }
}
