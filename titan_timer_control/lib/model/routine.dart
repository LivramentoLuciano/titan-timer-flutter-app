import 'package:flutter/material.dart';

class Routine with ChangeNotifier {
  num _tWork, _tRest, _tRestSets;
  num _max_tWork, _max_tRest, _max_tRestSets;
  num _rounds, _sets;
  num _maxRounds, _maxSets;
  String _mode;

  Routine({tWork, tRest, tRestSets, rounds, sets})
      : _tWork = tWork,
        _tRest = tRest,
        _tRestSets = tRestSets,
        _rounds = 3,
        _sets = 2,
        _maxRounds = 15,
        _maxSets = 15,
        _mode = "amrap";

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

  num get maxRounds => _maxRounds;
  set maxRounds (num max) {
    _maxRounds = max;
    notifyListeners();
  }

  num get maxSets => _maxSets;
  set maxSets (num max) {
    _maxSets = max;
    notifyListeners();
  }

  String get mode => _mode;
  set mode(String m) {
    _mode = m;
    notifyListeners();
  }

  num get max_tWork => _max_tWork;
  set max_tWork (num max) {
    _max_tWork = max;
    notifyListeners();
  }

  num get max_tRest => _max_tRest;
  set max_tRest (num max) {
    _max_tRest = max;
    notifyListeners();
  }

  num get max_tRestSets => _max_tRestSets;
  set max_tRestSets (num max) {
    _max_tRestSets = max;
    notifyListeners();
  }

  // reemplaza a lo que deberia hacer un constructor tipo Routine.AMRAP, etc  
  void defaults(String mode) {
    if (mode == "amrap"){
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
    } else if (mode == "hiit"){
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
    } else if (mode == "tabata"){
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
    } else if (mode == "combate"){
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
    }
  }

  String toString() =>
      "tWork: $_tWork, tRest: $_tRest, tRestSets: $_tRestSets,...";
}
