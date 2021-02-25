import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';
import 'package:titan_timer_control/view/widgets/bluetooth/devices_list.dart';

class SearchBluetooth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _showDevices() {
      showDialog(
        context: context,
        builder: (context) {
          final cronometroBT = Provider.of<CronometroBluetooth>(context);
          cronometroBT.btScan();
          return DevicesListDialog(cronometroBT: cronometroBT);
        },
      ).then((result){
        print(result); // la salida del dialogo
      });
    }

    return IconButton(
      icon: Icon(Icons.bluetooth),
      onPressed: _showDevices,
    );
  }
}