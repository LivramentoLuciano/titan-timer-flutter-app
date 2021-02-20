import 'package:flutter/material.dart';

class ControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Control")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Control Screen"),
            RaisedButton(onPressed: (){}, child: Text("Sig"))
          ],
        ),
      ),
    );
  }
}
