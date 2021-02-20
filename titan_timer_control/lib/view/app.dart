import 'package:flutter/material.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/view/screens/bt_connection.dart';
import 'package:titan_timer_control/view/screens/control.dart';
import 'package:titan_timer_control/view/screens/modes_screen.dart';
import 'package:titan_timer_control/view/screens/routine_settings.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Titan Timer Control",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MODES_ROUTE,
      routes: {
        MODES_ROUTE: (context) => ModesScreen(),
        ROUTINE_SETTINGS_ROUTE: (context) => RoutineSettingsScreen(),
        BT_CONNECTION_ROUTE: (context) => BtConnectionScreen(),
        CONTROL_ROUTE: (context) => ControlScreen(),
      },
    );
  }
}
