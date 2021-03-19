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

class TrainingMode {
  String name, description, imageUrl;
  TrainingMode({this.name, this.description, this.imageUrl});
}

final List trainingModes = <TrainingMode>[
  TrainingMode(
    name: "amrap",
    description: "Haz todas las repeticiones que puedas en el tiempo dado.",
    imageUrl: "assets/img_gym.jpg",
  ),
  TrainingMode(
    name: "hiit",
    description:
        "Intervalos de alta intensidad, combinado ejercicios aeróbicos y anaeróbicos.",
    imageUrl: "assets/img_gym2.jpg",
  ),
  TrainingMode(
    name: "tabata",
    description: "Intervalos de alta intensidad y pequeño tiempo de descanso.",
    imageUrl: "assets/img_gym4.jpg",
  ),
  TrainingMode(
    name: "combate",
    description:
        "Podrás configurar el tiempo de Round deseado para combates de boxeo, kickboxing y más.",
    imageUrl: "assets/img_box.jpg",
  ),
];
