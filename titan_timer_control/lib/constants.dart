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


Map<String, dynamic> trainingModes = {
  "amrap": {
    "description": "Haz todas las repeticiones que puedas en el tiempo dado.",
    "img-icon": "local-files/img_gym.jpg",
  },
  "hiit": {
    "description": "Intervalos de alta intensidad, combinado ejercicios aeróbicos y anaeróbicos.",
    "img-icon": "local-files/img_gym2.jpg",
  },
  "tabata": {
    "description": "Intervalos de alta intensidad y pequeño tiempo de descanso.",
    "img-icon": "local-files/img_gym4.jpg",
  },
  "combate": {
    "description": "Podrás configurar el tiempo de Round deseado para combates de boxeo, kickboxing y más.",
    "img-icon": "local-files/img_box.jpg",
  },
};