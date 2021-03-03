import 'package:flutter/material.dart';

// Referencia para el boton de Play/Pausa (estado del cronometro) ???
enum RoutineState { STARTED, PAUSED, STOPPED }

class Routine with ChangeNotifier {
  num _tWork, _tRest, _tRestSets;
  num max_tWork, max_tRest, max_tRestSets;
  num min_tWork, min_tRest, min_tRestSets;
  num _rounds, _sets;
  num maxRounds, maxSets;
  String mode;
  RoutineState _state; // playing, paused, ...

  Routine({tWork, tRest, tRestSets, rounds, sets})
      : _tWork = tWork,
        _tRest = tRest,
        _tRestSets = tRestSets,
        _rounds = 3,
        _sets = 2,
        _state = RoutineState.STOPPED;

  num get tWork => _tWork;
  set tWork(num tW) {
    _tWork = tW;
    notifyListeners();
  }

  num get tRest => _tRest;
  set tRest(num tR) {
    _tRest = tR;
    notifyListeners();
  }

  num get tRestSets => _tRestSets;
  set tRestSets(num tRS) {
    _tRestSets = tRS;
    notifyListeners();
  }

  num get rounds => _rounds;
  set rounds(num r) {
    _rounds = r;
    notifyListeners();
  }

  num get sets => _sets;
  set sets(num s) {
    _sets = s;
    notifyListeners();
  }

  RoutineState get state => _state;
  set state(RoutineState s) {
    _state = s;
    notifyListeners();
  }

  List<dynamic> get settings => [
    mode,
    tWork,
    tRest,
    tRestSets,
    rounds,
    sets,
  ];

  // reemplaza a lo que deberia hacer un constructor tipo Routine.AMRAP, etc
  void defaults(String mode) {
    if (mode == "amrap") {
      rounds = 2;
      sets = 1;
      tWork = 900;
      tRest = 180;
      tRestSets = 0;
      maxRounds = 5;
      maxSets = 1;
      max_tWork = 1200;
      max_tRest = 300;
      max_tRestSets = 0;
      min_tWork = 60;
      min_tRest = 30;
      min_tRestSets = 0;
    } else if (mode == "hiit") {
      rounds = 8;
      sets = 4;
      tWork = 20;
      tRest = 20;
      tRestSets = 120;
      maxRounds = 15;
      maxSets = 8;
      max_tWork = 60;
      max_tRest = 60;
      max_tRestSets = 300;
      min_tWork = 5;
      min_tRest = 0;
      min_tRestSets = 10;
    } else if (mode == "tabata") {
      rounds = 8;
      sets = 4;
      tWork = 50;
      tRest = 10;
      tRestSets = 120;
      maxRounds = 15;
      maxSets = 8;
      max_tWork = 120;
      max_tRest = 120;
      max_tRestSets = 180;
      min_tWork = 5;
      min_tRest = 0;
      min_tRestSets = 10;
    } else if (mode == "combate") {
      rounds = 10;
      sets = 1;
      tWork = 120;
      tRest = 60;
      tRestSets = 0;
      maxRounds = 15;
      maxSets = 1;
      max_tWork = 180;
      max_tRest = 120;
      max_tRestSets = 0;
      min_tWork = 30;
      min_tRest = 30;
      min_tRestSets = 0;
    }
  }

  // Para mostrar o no informacion sobre 'Sets', 'DescansoSets'
  // quizas podria ser directamente si 'sets>1' pero Ojo con los defaults puestos
  bool get withSets => !(mode == "amrap" || mode == "combate");

  String toString() =>
      "tWork: $_tWork, tRest: $_tRest, tRestSets: $_tRestSets,...";
}
