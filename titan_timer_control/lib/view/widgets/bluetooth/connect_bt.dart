import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';

class BtDevicesWidget extends StatelessWidget {
  const BtDevicesWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cronometroBT = Provider.of<CronometroBluetooth>(context);
    List<DeviceChoice> _deviceChoicesList = [];

    _handleSelected(DeviceChoice deviceChoiced) {
      print("Seleccionó ${deviceChoiced.name}");
    }

    return PopupMenuButton(
      itemBuilder: (context) {
        // if (cronometroBT.targetsAvailable == 0) ???
        cronometroBT.btScan();

        // Cada target disponible lo agrego a mis 'Choices'
        cronometroBT.targetDevicesList.forEach((device) {
          _deviceChoicesList.add(DeviceChoice(name: device.name));
        });

        // Muestro Devices para conectar (asumo que se ira llenando la lista desde el Provider)
        return _deviceChoicesList.map((deviceChoice) {
          return PopupMenuItem<DeviceChoice>(
            value: deviceChoice,
            child: Text(
              "${deviceChoice.name}",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          );
        }).toList();
      },
      icon: Icon(Icons.bluetooth),
      onSelected: _handleSelected,
    );
  }
}

class DeviceChoice {
  final String name;
  DeviceChoice({this.name});
}
