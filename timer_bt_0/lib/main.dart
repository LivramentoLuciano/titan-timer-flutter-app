
import 'package:flutter/material.dart';

import 'package:timer_bt_0/screens/BT_Connection.dart';
import 'package:timer_bt_0/screens/ConfigRoutine.dart';
import 'package:timer_bt_0/screens/RoutineModes.dart';
import 'package:timer_bt_0/screens/RoutinePlay.dart';
import 'package:flutter/services.dart';
import 'package:timer_bt_0/screens/RoutinePlayWithoutTimer.dart';
import 'package:timer_bt_0/widgets/appThemes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(TimerBTApp());
  });
}

class TimerBTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Training Timer",
      debugShowCheckedModeBanner: false,
      theme: appTheme, //ThemeData.dark(), // 
      initialRoute: '/RoutineMode',
      routes: {
        '/BT_Connection': (context) => BT_Connection_Screen(),
        '/RoutineMode': (context) => RoutineMode_Screen(),
        '/ConfigRoutine': (context) => ConfigRoutine_Screen(),
        '/RoutinePlay': (context) => RoutinePlayWithoutTimer_Screen(),//RoutinePlay_Screen()
      },
    );
  }
}
