// Agrego el package de mis métodos BT, para poder incoporar aquí la comunicación BT
// No lo había hecho en un principio así, porque pretendia dejarlo genérico y no ligado unicamente a BT
import 'package:timer_bt_0/widgets/BT_methods.dart';

class Routine {
  int workTime, restTime, restBtwnSetsTime, totalRounds, totalSets;
  int maxWorkTime,
      maxRestTime,
      maxRestBtwnSetsTime,
      maxTotalRounds,
      maxTotalSets;
  int actualRound, actualSet;
  // 'timeLeft' lo coloco dentro del modelo para solucionar el acceso a este desde otros widgets (roundSetDisplay) para el +1/-1 de roundSet
  // Es la duracion del timer que variará según el 'state' (Work, rest...)
  int timeLeft;
  int initialPrepareTime, finishAlarmTime;
  String state =
      'NONE'; //Work, Rest, RestBtwnSets, NONE, Finished?  (para saber en que estado se encuentra la rutina)
  String mode; //amrap, tabata, combat... (tipo de rutina)
  bool
      isWithBT; // Por defecto 'true' para poder comenzar una nueva rutina sin cerrar la app (BT sigue conectado y saltea la screen de BT_Connection)

  Map<String, String> modeHeader = {
    'amrap': 'A',
    'tabata': 'T',
    'combat': 'C',
  };

  Map<String, String> btHeader = {
    'start': 'S',
    'pause': 'P',
    'stop': 's',
    'resume': 'R',
    'resincronize': 'r',
    'roundIncrement': 'I',
    'setIncrement': 'i',
    'roundDecrement': 'D',
    'setDecrement': 'd',
    'secondsForward': 'f',
    'secondsBackward': 'b',
  };

  Routine({
    this.workTime = 50,
    this.restTime = 10,
    this.restBtwnSetsTime = 180,
    this.totalRounds = 2,
    this.totalSets = 1,
  });

  Routine.amrap({
    this.workTime = 900,
    this.restTime = 180,
    this.restBtwnSetsTime = 0,
    this.actualRound = 1,
    this.totalRounds = 2,
    this.actualSet = 1,
    this.totalSets = 1,
    this.mode = "amrap",
    this.state = "NONE",
    this.maxWorkTime = 1200,
    this.maxRestTime = 300,
    this.maxTotalRounds = 6,
    this.maxTotalSets = 1,
    this.maxRestBtwnSetsTime = 0,
    this.initialPrepareTime = 3,
    this.finishAlarmTime = 5,
    this.isWithBT = true,
  });

  Routine.tabata({
    this.workTime = 50,
    this.restTime = 10,
    this.restBtwnSetsTime = 120,
    this.actualRound = 1,
    this.totalRounds = 6,
    this.actualSet = 1,
    this.totalSets = 4,
    this.mode = "tabata",
    this.state = "NONE",
    this.maxWorkTime = 120,
    this.maxRestTime = 60,
    this.maxTotalRounds = 10,
    this.maxTotalSets = 10,
    this.maxRestBtwnSetsTime = 240,
    this.initialPrepareTime = 3,
    this.finishAlarmTime = 3,
    this.isWithBT = true,
  });

  Routine.combat({
    this.workTime = 180,
    this.restTime = 60,
    this.restBtwnSetsTime = 0,
    this.actualRound = 1,
    this.totalRounds = 10,
    this.actualSet = 1,
    this.totalSets = 1,
    this.mode = "combat",
    this.state = "NONE",
    this.maxWorkTime = 180,
    this.maxRestTime = 120,
    this.maxTotalRounds = 15,
    this.maxTotalSets = 1,
    this.maxRestBtwnSetsTime = 0,
    this.initialPrepareTime = 3,
    this.finishAlarmTime = 10,
    this.isWithBT = true,
  });

  String toString() {
    return """
    Work: $workTime,
    Rest: $restTime,
    RestBtwSets: $restBtwnSetsTime,
    Rounds: $actualRound/$totalRounds,
    Sets: $actualSet/$totalSets,
    State: $state,
    Time left: $timeLeft
    """;
  }

  void roundIncrement() {
    if (actualRound < totalRounds) {
      actualRound++;
      timeLeft = workTime;
      state = 'work';
    } else {
      if (actualSet < totalSets) {
        actualRound = 1;
        actualSet++;
        timeLeft = workTime;
        state = 'work';
      } else {
        // Por ahora, pongo que no haga nada si estoy en el ultimo round del ultimo set
        // Deberia terminar la rutina, pero no lo hago porque de aca no tengo acceso al Timer que requeriria cancelarlo
        ///state = 'finished';
        ///timeLeft = workTime;
        ///actualRound = 1;
        ///actualSet = 1;
        ///t.cancel();
        ///y todo lo de la botonera (paused, started...)
      }
    }
    if (isWithBT) {
      enviarBT(data2Trama(datosRoundIncrementRoutineBT()));
    }
  }

  void roundDecrement() {
    timeLeft = workTime;
    state = 'work';
    if (actualRound > 1) {
      actualRound--;
    } else {
      if (actualSet > 1) {
        actualRound = totalRounds;
        actualSet--;
      } else {}
    }
    if (isWithBT) {
      enviarBT(data2Trama(datosRoundDecrementRoutineBT()));
    }
  }

  void setIncrement() {
    if (actualSet < totalSets) {
      actualSet++;
      actualRound = 1;
      timeLeft = workTime;
      state = 'work';
    } else {}
    if (isWithBT) {
      enviarBT(data2Trama(datosSetIncrementRoutineBT()));
    }
  }

  void setDecrement() {
    timeLeft = workTime;
    state = 'work';
    if (actualSet > 1) {
      actualSet--;
      actualRound = 1;
    } else {}
    if (isWithBT) {
      enviarBT(data2Trama(datosSetDecrementRoutineBT()));
    }
  }

  List<dynamic> datosStartRoutineBT() {
    List<dynamic> datos = [];

    datos = [
      btHeader['start'],
      mode,
      workTime,
      restTime,
      restBtwnSetsTime,
      totalRounds,
      totalSets
    ];
    return datos;
  }

  List<dynamic> datosResincronizeRoutineBT() {
    List<dynamic> datos = [];

    datos = [
      btHeader['resincronize'],
      mode,
      state,
      workTime,
      restTime,
      restBtwnSetsTime,
      totalRounds,
      totalSets,
      actualRound,
      actualSet,
      timeLeft
    ];
    return datos;
  }

  List<dynamic> datosPauseRoutineBT() {
    List<dynamic> datos = [];

    datos = [btHeader['pause']];
    return datos;
  }

  List<dynamic> datosStopRoutineBT() {
    List<dynamic> datos = [];

    datos = [btHeader['stop']];
    return datos;
  }

  List<dynamic> datosResumeRoutineBT() {
    List<dynamic> datos = [];

    datos = [btHeader['resume']];
    return datos;
  }

  List<dynamic> datosRoundIncrementRoutineBT() {
    List<dynamic> datos = [];

    datos = [btHeader['roundIncrement']];
    return datos;
  }

  List<dynamic> datosSetIncrementRoutineBT() {
    List<dynamic> datos = [];

    datos = [btHeader['setIncrement']];
    return datos;
  }

  List<dynamic> datosRoundDecrementRoutineBT() {
    List<dynamic> datos = [];

    datos = [btHeader['roundDecrement']];
    return datos;
  }

  List<dynamic> datosSetDecrementRoutineBT() {
    List<dynamic> datos = [];

    datos = [btHeader['setDecrement']];
    return datos;
  }

  List<dynamic> datosSincronizeRoutineBT() {
    List<dynamic> datos = [];

    datos = [
      btHeader['resincronize'],
      mode,
      workTime,
      restTime,
      restBtwnSetsTime,
      totalRounds,
      totalSets,
      actualRound,
      actualSet,
      timeLeft,
      state,
    ];
    return datos;
  }

  List<dynamic> datosSecondsForwardRoutineBT(int _seconds) {
    List<dynamic> datos = [];

    datos = [
      btHeader['secondsForward'],
      _seconds,
    ];
    return datos;
  }

  List<dynamic> datosSecondsBackwardRoutineBT(int _seconds) {
    List<dynamic> datos = [];

    datos = [
      btHeader['secondsBackward'],
      _seconds,
    ];
    return datos;
  }
}
