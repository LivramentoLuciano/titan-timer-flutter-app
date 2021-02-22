import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          FlatButton(
            onPressed: () {},
            child: Icon(Icons.fast_rewind, color: Colors.black, size: 30),
          ),
          FlatButton(
            onPressed: () {},
            child: Icon(Icons.replay_10, color: Colors.black, size: 30),
          ),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.play_arrow),
          ),
          FlatButton(
            onPressed: () {},
            child: Icon(Icons.forward_10, color: Colors.black, size: 30),
          ),
          FlatButton(
            onPressed: () {},
            child: Icon(Icons.fast_forward, color: Colors.black, size: 30),
          )
        ],
      ),
    );
  }
}
