final MODES_ROUTE = "/";
final ROUTINE_SETTINGS_ROUTE = "/routine_settings";
final BT_CONNECTION_ROUTE = "/bt_connection";
final CONTROL_ROUTE = "/control";

String mmss(num secs) {
  int mm = secs.toInt() ~/ 60;
  int ss = secs.toInt() % 60;
  String mmss =
      "${(mm < 10) ? '0' + mm.toString() : mm}:${(ss < 10) ? '0' + ss.toString() : ss}";
  return mmss;
}
