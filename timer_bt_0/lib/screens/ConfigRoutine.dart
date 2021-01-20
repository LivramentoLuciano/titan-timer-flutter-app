import 'package:flutter/material.dart';
import 'package:timer_bt_0/widgets/routineModel.dart';
import 'package:timer_bt_0/widgets/BT_methods.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

//Routine routine = Routine();
//var routine = Routine();
Routine routine;

class ConfigRoutine_Screen extends StatefulWidget {
  @override
  _ConfigRoutine_ScreenState createState() => _ConfigRoutine_ScreenState();
}

class _ConfigRoutine_ScreenState extends State<ConfigRoutine_Screen> {
  BluetoothDeviceState
      _deviceState; // Por si desea volver a generar una nueva rutina sin cerrar la app
  StreamSubscription<BluetoothDeviceState> _deviceStateSubscription;

  @override
  void didChangeDependencies() {
    if (targetDevice != null) {
      // Por si desea volver a generar una nueva rutina sin cerrar la app
      _deviceStateSubscription = targetDevice.state.listen((state) {
        setState(() {
          _deviceState = state;
          print(
              "ACTUALIZA STREAM STATE EN CONFIG ROUTINE SCREEN: $_deviceState");
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_deviceStateSubscription != null) {
      _deviceStateSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String selectedRoutine = ModalRoute.of(context).settings.arguments;
    final bool _fullconfiguration = selectedRoutine == 'tabata' ? true : false;
    //Routine routine;
    if (selectedRoutine == 'amrap')
      routine = Routine.amrap();
    else if (selectedRoutine == 'tabata')
      routine = Routine.tabata();
    else if (selectedRoutine == 'fight') routine = Routine.combat();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Configuración ${selectedRoutine[0].toUpperCase()}${selectedRoutine.substring(1)}"), //Text("Routine configuration:"),
        centerTitle: true,
        //backgroundColor: Colors.grey[850],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConfigItemSlideable(
                label: routine.mode == 'combat' ? 'fight' : "work",
                minValue: 0,
                maxValue: routine.maxWorkTime),
            Divider(thickness: 1, height: 5),
            ConfigItemSlideable(
                label: "rest", minValue: 0, maxValue: routine.maxRestTime),
            Divider(thickness: 1),
            Visibility(
              visible: _fullconfiguration,
              child: ConfigItemSlideable(
                label: "rest between sets",
                minValue: 0,
                maxValue: routine.maxRestBtwnSetsTime,
              ),
            ),
            Visibility(
              visible: _fullconfiguration,
              child: Divider(thickness: 1),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ConfigItemButtoned(
                    label: "Rounds",
                  ),
                  Visibility(
                    visible: _fullconfiguration,
                    child: ConfigItemButtoned(
                      label: "Sets",
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FlatButton(
                //color: Colors.black,
                onPressed: () {
                  // agrego cancelada de la subscripcion al stream que uso para saber si 'connected'BT
                  if (_deviceStateSubscription != null) {
                    _deviceStateSubscription.cancel();
                  }
                  //uso 'Replacemente' para salvar un error durante las pruebas que no me anda bien si vuelvo a la configuracion desde la de 'play'
                  Navigator.of(context).pushReplacementNamed(
                    _deviceState == BluetoothDeviceState.connected
                        ? '/RoutinePlay'
                        : '/BT_Connection', //'/RoutinePlay',
                    arguments: routine,
                  );
                  /*.then((result) {
                        print(routine);
                      });*/
                },
                child: Text(
                  "START",
                  style: Theme.of(context)
                      .textTheme
                      .display1, //TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ConfigItemButtoned extends StatefulWidget {
  final String label;

  const ConfigItemButtoned({
    this.label,
    Key key,
  }) : super(key: key);

  @override
  _ConfigItemButtonedState createState() => _ConfigItemButtonedState();
}

class _ConfigItemButtonedState extends State<ConfigItemButtoned> {
  int value;

  @override
  void initState() {
    // Inicia en valor por default, según modo de trabajo
    //print("init");
    this.widget.label == 'Rounds'
        ? this.value = routine.totalRounds
        : this.value = routine.totalSets;
    super.initState();
  }

  void _decrement() {
    if (this.value > 1) {
      setState(() {
        this.value--;
      });
      this.widget.label == 'Rounds'
          ? routine.totalRounds = this.value
          : routine.totalSets = this.value;
    }
  }

  void _increment() {
    if (this.widget.label == 'Rounds') {
      if (this.value < routine.maxTotalRounds) {
        setState(() {
          this.value++;
        });
      }
      routine.totalRounds = this.value;
    } else if (this.value < routine.maxTotalSets) {
      setState(() {
        this.value++;
      });
      routine.totalSets = this.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              this.widget.label + ":",
              style:
                  Theme.of(context).textTheme.display1.copyWith(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: _decrement,
                ),
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.display1.copyWith(
                      //fontSize: 24,
                      //color: Colors.white,
                      ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: _increment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigItemSlideable extends StatefulWidget {
  final String label;
  final int minValue, maxValue;
  const ConfigItemSlideable({
    Key key,
    @required this.label,
    @required this.maxValue,
    @required this.minValue,
  }) : super(key: key);

  @override
  _ConfigItemSlideableState createState() => _ConfigItemSlideableState();
}

class _ConfigItemSlideableState extends State<ConfigItemSlideable> {
  int _sliderValue;

  @override
  void initState() {
    _sliderValue = 10;
    this.widget.label == 'work' || this.widget.label == 'fight'
        ? _sliderValue = routine.workTime
        : this.widget.label == 'rest'
            ? _sliderValue = routine.restTime
            : _sliderValue = routine.restBtwnSetsTime;
    super.initState();
  }

  String _toMMSS(int value) {
    int mm = value ~/ 60;
    int ss = value % 60;
    String mmss =
        "${(mm < 10) ? '0' + mm.toString() : mm}:${(ss < 10) ? '0' + ss.toString() : ss}";
    //print(mmss);
    return mmss;
  }

  int _discretizeSliderValue(int value) {
    int discretizer = 10; // seconds
    return (value ~/ discretizer) * discretizer;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "${this.widget.label[0].toUpperCase()}${this.widget.label.substring(1)}:",
                style: Theme.of(context).textTheme.display1.copyWith(
                      fontSize: 18,
                      //color: Colors.white,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  //this.widget.label + " " +
                  _toMMSS(_sliderValue),
                  style: Theme.of(context).textTheme.display1.copyWith(
                      //fontSize: 24,
                      //color: Colors.white,
                      ),
                ),
              ),
            ),
            Container(
              //color: Colors.white10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.grey[200]),
              child: Slider(
                value: _sliderValue.toDouble(),
                onChanged: (newValue) {
                  setState(() {
                    _sliderValue = routine.mode == 'tabata'
                        ? newValue.toInt()
                        : _discretizeSliderValue(newValue.toInt());
                  });

                  /// corregir, NO hacer con label
                  this.widget.label == 'work' || this.widget.label == 'fight'
                      ? routine.workTime = _sliderValue
                      : this.widget.label == 'rest'
                          ? routine.restTime = _sliderValue
                          : routine.restBtwnSetsTime = _sliderValue;
                  print(routine);
                },
                min: this.widget.minValue.toDouble(),
                max: this.widget.maxValue.toDouble(),
                activeColor: Colors.black,
                inactiveColor: Colors.black12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
