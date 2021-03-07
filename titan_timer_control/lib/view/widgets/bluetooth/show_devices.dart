import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';
import 'package:titan_timer_control/view/widgets/bluetooth/devices_list.dart';

class SearchBluetooth extends StatelessWidget {
  final Function startNotifySubscription;
  SearchBluetooth({this.startNotifySubscription});

  @override
  Widget build(BuildContext context) {
    final _cronometroBT = Provider.of<CronometroBluetooth>(context);
    _showDevices() {
      showDialog(
        context: context,
        builder: (context) {
          _cronometroBT.btScan();
          return DevicesListDialog(cronometroBT: _cronometroBT);
        },
      ).then((result) {
        print(result); // la salida del dialogo
        if (result == "conectado") {
          startNotifySubscription();
        }
      });
    }

    return IconButton(icon: Icon(Icons.bluetooth), onPressed: _showDevices);
  }
}
