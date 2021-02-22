import 'package:flutter/material.dart';

class Routine with ChangeNotifier {
  num _tWork, _tRest, _tRestSets;
  num _rounds, _sets;

  Routine({tWork, tRest, tRestSets, rounds, sets})
      : _tWork = tWork,
        _tRest = tRest,
        _tRestSets = tRestSets;

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

  String toString() =>
      "tWork: $_tWork, tRest: $_tRest, tRestSets: $_tRestSets,...";
}
