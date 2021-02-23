// Objeto Bluetooth que representara la conexion con el 'Cronometro BT'
// Tiene distitnas cuestions asociadas al uso de Bluetooth -> Flutter_blue (veerrr)
// y metodos para enviar datos asociados a la interfaz de mi App (sendPlay, sendPause, sendRoundUp, etc)

import 'package:flutter/material.dart';

class CronometroBluetooth with ChangeNotifier {
  bool _connected;
  CronometroBluetooth():_connected=false;

  bool get connected => _connected;
  set connected(bool c) => _connected = c;

  sendPlay() => "Envia Play a BT";
  sendPause()=> "Envia Pause a BT";
  sendRoundUp()=> "Envia RoundUp a BT";
  sendRoundDown()=> "Envia RoundDown a BT";
}