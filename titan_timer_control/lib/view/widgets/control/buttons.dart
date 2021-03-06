import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';

class ControlButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cronometroBT = Provider.of<CronometroBluetooth>(context);

    Widget _playPauseIcon() =>
        Row(children: [Icon(Icons.play_arrow), Text("/"), Icon(Icons.pause)]);

    _handlePlayPause() => cronometroBT.sendPlayPause();

    // dejo los handler aunque ahora solo envian BT
    // si tuviera timer y round/set actual, deberia actualizarlos aca
    _handleRoundDown() => cronometroBT.sendRoundDown();
    _handleRoundUp() => cronometroBT.sendRoundUp();
    _handleReplay() => cronometroBT.sendReplay();
    _handleForward() => cronometroBT.sendForward();

    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 60,
                child: FlatButton(
                  onPressed: _handleRoundDown,
                  child: Icon(Icons.fast_rewind, color: Colors.black, size: 30),
                  padding: EdgeInsets.all(0),
                ),
              ),
              SizedBox(
                width: 60,
                child: FlatButton(
                  onPressed: _handleReplay,
                  child: Icon(Icons.replay_10, color: Colors.black, size: 30),
                  padding: EdgeInsets.all(0),
                ),
              ),
              FloatingActionButton.extended(
                onPressed: _handlePlayPause,
                label: _playPauseIcon(),
              ),
              SizedBox(
                width: 60,
                child: FlatButton(
                  onPressed: _handleForward,
                  child: Icon(Icons.forward_10, color: Colors.black, size: 30),
                  padding: EdgeInsets.all(0),
                ),
              ),
              SizedBox(
                width: 60,
                child: FlatButton(
                  onPressed: _handleRoundUp,
                  child:
                      Icon(Icons.fast_forward, color: Colors.black, size: 30),
                  padding: EdgeInsets.all(0),
                ),
              ),
            ],
          ),
          // FlatButton(onPressed: () {}, child: Text("Reset")) // o cargar Rutina ? (porque nadie va a entender que es para poder recargar rutina si fui hacia atras y volvi)
        ],
      ),
    );
  }
}
