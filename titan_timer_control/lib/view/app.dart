import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titan_timer_control/bluetooth/bluetooth.dart';
import 'package:titan_timer_control/constants.dart';
import 'package:titan_timer_control/model/routine.dart';
import 'package:titan_timer_control/view/screens/bt_connection.dart';
import 'package:titan_timer_control/view/screens/control_screen.dart';
import 'package:titan_timer_control/view/screens/modes_screen.dart';
import 'package:titan_timer_control/view/screens/routine_settings.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Routine>(create: (context) => Routine(tWork: 20, tRest: 20, tRestSets: 30)),
        ChangeNotifierProvider<CronometroBluetooth>(create: (context) => CronometroBluetooth()),
      ],
      child: MaterialApp(
        title: "Titan Timer Control",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: MODES_ROUTE,
        routes: {
          MODES_ROUTE: (context) => ModesScreen(),
          ROUTINE_SETTINGS_ROUTE: (context) => RoutineSettingsScreen(),
          BT_CONNECTION_ROUTE: (context) => BtConnectionScreen(),
          CONTROL_ROUTE: (context) => ControlScreen(),
        },
      ),
    );
  }
}
