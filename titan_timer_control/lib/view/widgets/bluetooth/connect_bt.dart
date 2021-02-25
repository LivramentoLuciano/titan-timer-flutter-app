import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
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

    _handleSelected(DeviceChoice deviceChoiceSelected) {
      cronometroBT.targetDevice = deviceChoiceSelected.device;
      // cronometroBT.stopScan();
      cronometroBT.connect();
    }

    return PopupMenuButton(
      itemBuilder: (context) {
        // if (cronometroBT.targetsAvailable == 0) ???
        // Agregar if (isScanning) return [] omitir scaneo -> ver flutterBlue.isScanning
        cronometroBT.btScan();

        // Cada target disponible lo agrego a mis 'Choices'
        cronometroBT.targetDevicesList.forEach((device) {
          _deviceChoicesList.add(DeviceChoice(device: device));
        });

        // Muestro Devices para conectar (asumo que se ira llenando la lista desde el Provider)
        return _deviceChoicesList.map((deviceChoice) {
          return PopupMenuItem<DeviceChoice>(
            value: deviceChoice,
            child: Text(
              "${deviceChoice.device.name}",
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
  final BluetoothDevice device;
  DeviceChoice({this.device});
}
