// Objeto Bluetooth que representara la conexion con el 'Cronometro BT'
// Tiene distitnas cuestions asociadas al uso de Bluetooth -> Flutter_blue (veerrr)
// y metodos para enviar datos asociados a la interfaz de mi App (sendPlay, sendPause, sendRoundUp, etc)

import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:titan_timer_control/model/routine.dart';

// Constants
final String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb";
final String CHARACTERISTIC_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb";
final String TARGET_DEVICE_NAME = "Cronometro";

final String TRAMA_INI = '{';
final String TRAMA_END = '}';
final String TRAMA_SEP = ';';
final String LOAD_ROUTINE_HEADER = "L";
final String START_HEADER = "S";
final String PAUSE_HEADER = "P";
final String RESUME_HEADER = "s";
final String ROUND_UP_HEADER = "R";
final String ROUND_DOWN_HEADER = "r";
final String REPLAY_HEADER = "b";
final String FORWARD_HEADER = "f";
final String RESPONSE_OK_HEADER = 'K'; // desde el micro
final String FINISHED_HEADER = 'F'; // desde el micro
final String TIMER_STATE_HEADER =
    'T'; // le pido el 'state' (cuando vuelvo de background)

// Convierto el state recibido como char al valor usado en la app
final Map<String, String> stateCharToString = {
  "s": "started",
  "o": "stopped",
  "p": "paused",
};

class CronometroBluetooth with ChangeNotifier {
  // Estos son generales -> Deberian estar por fuera de CronometroBluetooth
  FlutterBlue flutterBlue;
  StreamSubscription<ScanResult> scanSubscription;
  List<BluetoothDevice> scanResults;
  List<BluetoothDevice> targetDevicesList; // Lista los 'target' disponibles

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristics;
  StreamSubscription<BluetoothDeviceState> stateSubscription;
  BluetoothDeviceState state; // Estado de conexion al target
  StreamSubscription<List<int>> notifySubscription; // Recepcion de mensajes

  String _timerState;

  CronometroBluetooth()
      : flutterBlue = FlutterBlue.instance,
        targetDevicesList = [],
        _timerState = "stopped";

  String get timerState => _timerState;
  set timerState(String s) {
    _timerState = s;
    print("timerState seteado : $_timerState");
    notifyListeners();
  }

  Future<String> sendLoadRoutine(List<dynamic> _datos) async {
    String _header = LOAD_ROUTINE_HEADER;
    final _result = await _sendData(_header, _datos);
    return Future.value(_result);
  }

  Future<String> sendStart() async {
    String _header = START_HEADER;
    List<String> _datos = [];
    final _result = await _sendData(_header, _datos);
    return _result;
  }

  Future<String> sendPause() async {
    String _header = PAUSE_HEADER;
    List<String> _datos = [];
    final _result = await _sendData(_header, _datos);
    return _result;
  }

  Future<String> sendResume() async {
    String _header = RESUME_HEADER;
    List<String> _datos = [];
    final _result = await _sendData(_header, _datos);
    return _result;
  }

  Future<String> sendRoundUp() async {
    String _header = ROUND_UP_HEADER;
    List<String> _datos = [];
    final _result = await _sendData(_header, _datos);
    return _result;
  }

  Future<String> sendRoundDown() async {
    String _header = ROUND_DOWN_HEADER;
    List<String> _datos = [];
    final _result = await _sendData(_header, _datos);
    return _result;
  }

  Future<String> sendReplay(Routine _routine) async {
    String _header = REPLAY_HEADER;
    List<dynamic> _datos = [_routine.deltaSeconds];
    final _result = await _sendData(_header, _datos);
    return _result;
  }

  Future<String> sendForward(Routine _routine) async {
    String _header = FORWARD_HEADER;
    List<dynamic> _datos = [_routine.deltaSeconds];
    final _result = await _sendData(_header, _datos);
    return _result;
  }

  Future<String> sendRequestTimerState() async {
    String _header = TIMER_STATE_HEADER;
    List<String> _datos = [];
    final _result = await _sendData(_header, _datos);
    return _result;
  }

  // Future -> Devolver msj de "errores", "ok"
  // Recibo 'header' y 'datos []' -> Armo trama antes de enviar
  Future<String> _sendData(String _header, List<dynamic> _datos) async {
    if (targetCharacteristics == null)
      return Future.error("Error: Caracteristica Nula");

    String _trama = _makeTrama(header: _header, datos: _datos);
    List<int> bytes = utf8.encode(_trama);
    final _result = await targetCharacteristics.write(bytes);
    return _result;
  }

  String _makeTrama({@required String header, @required List<dynamic> datos}) {
    String _trama = TRAMA_INI + header + TRAMA_SEP;
    if (datos.isNotEmpty)
      datos.forEach((dato) {
        if (!(dato is String)) dato = "$dato";
        _trama += dato + TRAMA_SEP;
      });
    _trama += TRAMA_END;
    return _trama;
  }

  // Estos metodos son generales -> Tamb creo que deberian estar por fuera de CronometroBluetooth
  btScan() {
    scanResults = [];
    scanSubscription =
        flutterBlue.scan(timeout: Duration(seconds: 5)).listen((result) {
      scanResults.add(result.device);
      if (isCronometroTitan(result)) {
        if (!targetDevicesList.contains(result.device)) {
          targetDevicesList.add(result.device);
          notifyListeners();
        }
      }
    }, onDone: () {
      print("Termino el scanStream");
      notifyListeners();
    });
  }

  stopScan() {
    flutterBlue.stopScan();
    scanSubscription.cancel();
    notifyListeners();
  }

  Future<void> connect() async {
    if (targetDevice == null) return;
    await targetDevice.connect();
    await _discoverServices();
  }

  Future<void> _discoverServices() async {
    if (targetDevice == null) return;
    List<BluetoothService> services = await targetDevice.discoverServices();

    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID)
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristics = characteristic;
            // connected !!
          }
        });
    });
    startStateSubscription(); // Inicio subscripcion de estado de conexion
  }

  disconect() {}

  // subscripcion: dispositivo 'conectado', 'desconectado', 'conectando', 'desconectando'
  void startStateSubscription() {
    stateSubscription = targetDevice.state.listen((_state) {
      state = _state;
      print("Actualiza 'state' bluetooth: $_state");
    });
  }

  cancelStateSubscription() =>
      (stateSubscription != null) ? stateSubscription.cancel() : null;

  // Comienza a 'escuchar', recepcion de mensajes
  startNotifySubscription() async {
    await targetCharacteristics.setNotifyValue(true);

    print("Inicio notify Subscription");
    notifySubscription = targetCharacteristics.value.listen((_value) {
      final _data = utf8.decode(_value);
      final _trama = getTrama(_data);
      print("Data recibida: $_data");

      if (_trama != null) processCommand(_trama);
    });
  }

  cancelNotifySubscription() async =>
      (notifySubscription != null) ? await notifySubscription.cancel() : null;

  // Solo admito tramas correctas
  String getTrama(String _data) {
    bool _isValidTrama() => (_data.contains(TRAMA_INI) &&
        _data.contains(TRAMA_END)); // Sirve por ahora, para pruebas
    String _trama;

    if (_isValidTrama())
      _trama = _data.substring(
          _data.indexOf(TRAMA_INI) + 1, _data.indexOf(TRAMA_END));

    return _trama;
  }

  void processCommand(String _trama) {
    final List<String> _tramaValues = _trama.split(TRAMA_SEP);

    final String _header = _tramaValues[0]; // obtengo el Header
    final List<String> _data = _tramaValues; // copio
    _data.removeAt(0); // elimino el Header, me quedo con los 'datos'

    // Las respuestas solo tendran un dato por ahora: el comando al que estan respondiendo
    final String _cmd = _data[0];
    if (_header == RESPONSE_OK_HEADER) {
      if (_cmd == LOAD_ROUTINE_HEADER)
        sendStart();
      else if (_cmd == START_HEADER)
        timerState = "started";
      else if (_cmd == PAUSE_HEADER)
        timerState = "paused";
      else if (_cmd == RESUME_HEADER)
        timerState = "resumed";
      else if (_cmd == ROUND_UP_HEADER)
        timerState = "paused";
      else if (_cmd == ROUND_DOWN_HEADER) timerState = "paused";
    } else if (_header == TIMER_STATE_HEADER) {
      print(
          "Recibi el 'state' actual: ${stateCharToString[_cmd]} -> Lo actualizo...");
      timerState = stateCharToString[_cmd];
    } else if (_header == FINISHED_HEADER) timerState = "stopped";
  }

  int get targetsAvailable => targetDevicesList.length;

  bool isCronometroTitan(ScanResult result) =>
      result.device.name == TARGET_DEVICE_NAME;
}
