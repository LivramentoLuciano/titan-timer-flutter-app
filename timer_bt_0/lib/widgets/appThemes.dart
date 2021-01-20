import 'package:flutter/material.dart';

final Color _primaryColor = Colors.white; //Colors.grey[850];
final Color _backgroundcolor = Colors.white;
final Color _appBarColor = Colors.grey[850];
final Color _textColor = Colors.black;
final Color _accentColor = Colors.blueAccent;
final Color graphicTimeColor = Colors.lightBlueAccent;
final Color graphicRoundColor= Colors.orangeAccent;
final Color graphicSetColor = Colors.greenAccent;


final ThemeData appTheme = ThemeData( //ThemeData(
  primaryColor: Colors.white, //Color.fromARGB(255, 34, 49, 55),
  //accentColor: Colors.amberAccent, //Colors.orange[500],
  //fontFamily: ,
  /*textTheme: TextTheme(
    display1: TextStyle(color: Colors.white),
    headline: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
    body1: TextStyle(fontSize: 14),
  ),*/
  backgroundColor: _backgroundcolor,
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.amberAccent, 
    inactiveTrackColor: Colors.amberAccent[100],
    //overlayColor: Color.fromARGB(100, 34, 49, 55),
    //trackHeight: 10
  )
);