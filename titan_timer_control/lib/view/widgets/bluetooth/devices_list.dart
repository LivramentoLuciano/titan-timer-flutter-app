import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';

class DevicesListDialog extends StatefulWidget {
  const DevicesListDialog({
    Key key,
    @required this.cronometroBT,
  }) : super(key: key);

  final CronometroBluetooth cronometroBT;

  @override
  _DevicesListDialogState createState() => _DevicesListDialogState();
}

class _DevicesListDialogState extends State<DevicesListDialog> {
  List<DeviceChoice> _deviceChoiceList;

  @override
  void initState() {
    _deviceChoiceList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _handleSelected(DeviceChoice deviceChoiceSelected) async {
      widget.cronometroBT.targetDevice = deviceChoiceSelected.device;
      widget.cronometroBT.stopScan();
      await widget.cronometroBT.connect();
      Navigator.of(context)
          .pop("conectado"); // chequear que 'connect' devuelva Ok antes
    }

    return AlertDialog(
      title: Text("Elige un Cronómetro"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                height: 11,
                width: 11,
                margin: EdgeInsets.only(right: 8),
                child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black.withAlpha(150))),
              ),
              Text("Disponibles"),
            ],
          ),
          Divider(height: 1, thickness: 1),
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              itemCount: widget.cronometroBT.targetDevicesList.length,
              itemBuilder: (context, index) {
                _deviceChoiceList = widget.cronometroBT.targetDevicesList
                    .map((targetDevice) => DeviceChoice(device: targetDevice))
                    .toList();
                return ListTile(
                  title: Text(_deviceChoiceList[index].device.name + " - ABCD"),
                  onTap: () => _handleSelected(_deviceChoiceList[index]),
                );
              },
              separatorBuilder: (context, index) => Divider(thickness: 1),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              print("MANDA A PARAR SCAN FROM CANCEL");
              widget.cronometroBT.stopScan();
              Navigator.of(context).pop("cancel");
            },
            child: Text("CANCELAR"))
      ],
    );
  }
}

class DeviceChoice {
  final BluetoothDevice device;
  DeviceChoice({this.device});
}
