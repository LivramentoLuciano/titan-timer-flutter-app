import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';

class ControlButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cronometroBT = Provider.of<CronometroBluetooth>(context);

    _handlePlayPause() {
      cronometroBT.sendStart();
    }

    // dejo los handler aunque ahora solo envian BT
    // si tuviera timer y round/set actual, deberia actualizarlos aca
    _handlePause() => cronometroBT.sendPause();
    _handleRoundDown() => cronometroBT.sendRoundDown();
    _handleRoundUp() => cronometroBT.sendRoundUp();
    _handleReplay() => cronometroBT.sendReplay();
    _handleForward() => cronometroBT.sendForward();

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
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
            child: Icon(Icons.play_arrow),
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
    );
  }
}
