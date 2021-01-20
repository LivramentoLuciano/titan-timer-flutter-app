
// Métodos para utilizar en distintas partes del programa
String toMMSS(num time) {
    int mm = time ~/ 60;
    int ss = time % 60;
    String mmss =
        "${(mm < 10) ? '0' + mm.toString() : mm}:${(ss < 10) ? '0' + ss.toString() : ss}";
    //print(mmss);
    return mmss;
  }