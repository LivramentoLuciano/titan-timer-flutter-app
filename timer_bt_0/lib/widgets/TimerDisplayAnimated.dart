import 'package:flutter/material.dart';
import 'package:timer_bt_0/screens/ConfigRoutine.dart';
import 'package:timer_bt_0/widgets/appThemes.dart';
import 'methods.dart';

import 'dart:math' as math;

/// IMPORTANTE (lei en un proyecto)
/// Esta extracción que hice, al contener muchos widgets
/// y estar relacionada con un texto que tiene 'state'
/// no sería óptima en cuanto a consumo de recursos
/// ya que al cambiar 'state' va a redibujar todo este widget
/// lo ideal sería solo extraer el widget 'Text' (creo)
/// y que solo se redibuje ese en cada cambio
/// Info: https://www.freecodecamp.org/news/how-fast-is-flutter-i-built-a-stopwatch-app-to-find-out-9956fa0e40bd/
///
/// 29/02/2020: Update - Paso TimerDisplayAnimated a 'statelees' porque, revisandolo bien no requiere un 'estado'
///             y porque si usaba 'estado' no me actualizaba ciertas cosas
///             (ejemplo, al _roundIncrement, actualizaba el painter pero no el texto)
///             (resulta que no era por eso que no andaba, no sé donde está el error o cómo resolverlo)
///             RESUELTO: en StopWatchView -> Puse RoundSetDisplay ahi adentor como un método, el cual devuelve
///             el Widget, y tiene acceso a setState de las variables de Stopwatch, para poder redibujar el Display
/// Todas las modifaciones q involucran al routine.state = 'finish' es para que no muestre GO! sino 0:0
/// con toda  la barra de RoundSet llena

class TimerDisplayAnimated_stateless extends StatelessWidget {
  final int _timeLeft;
  final String _routineState;
  final bool _started, _paused, _stopped, _resumed, _finishing;

  TimerDisplayAnimated_stateless({
    Key key,
    @required int timeLeft,
    @required String routineState,
    @required bool started,
    @required bool paused,
    @required bool stopped,
    @required bool resumed,
    @required bool finishing,
  })  : _timeLeft = timeLeft,
        _routineState = routineState,
        _started = started,
        _paused = paused,
        _stopped = stopped,
        _resumed = resumed,
        _finishing = finishing,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Align(
          alignment: FractionalOffset.center,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(
                    painter: CustomTimerPainter(
                      timeLeftPainter: this._timeLeft,
                      //animation: controller,
                      backgroundColor: Colors.black,//Theme.of(context).primaryColor,
                      timeColor: graphicTimeColor,//Colors.teal, //Color.fromARGB(255, 96, 2, 238),
                      roundsColor: graphicRoundColor,//Colors.amber[900],//Color.fromARGB(255, 144, 238, 2),
                      setsColor: graphicSetColor //Colors.lightBlueAccent[700], //Color.fromARGB(255, 238, 96, 2),
                    ),
                  ),
                ),
                Center(
                  child: Stack(
                    children: <Widget>[
                      Visibility(
                        visible: this._routineState != 'NONE',
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Text(
                              this._routineState != 'NONE' &&
                                      this._routineState != 'restarted'
                                  ? this._routineState != 'restBtwnSets'
                                      ? this._routineState == "init"
                                          ? "GET READY"
                                          : this._routineState.toUpperCase()
                                      : 'REST / SET'
                                  : '',
                              style: this._routineState == 'finished'
                                  ? Theme.of(context).textTheme.display1
                                  //.copyWith(color: Colors.white)
                                  : Theme.of(context).textTheme.display1,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            !(routine.state == 'restarted' ||
                                    routine.state == 'NONE')
                                ? Text(
                                    toMMSS(routine.timeLeft),
                                    style: Theme.of(context)
                                        .textTheme
                                        .display4
                                        .copyWith(
                                            color: this._finishing
                                                ? Colors.redAccent
                                                : Colors.black),
                                  )
                                : Text(
                                    "GO!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .display4
                                        .copyWith(
                                          color: Colors.black,//Theme.of(context).accentColor,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                            /*Visibility(
                              visible: widget._routineState != 'NONE',
                              child: Text(
                                widget._routineState != 'NONE'
                                    ? widget._routineState.toUpperCase()
                                    : '',
                                style: Theme.of(context).textTheme.display1,
                              ),
                            ),*/
                          ],
                        ),
                      ),
                      Visibility(
                        visible: true, /*!(routine.state == 'restarted' ||
                            routine.state == 'NONE'),*/
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Text(
                              "Press to " +
                                  "${this._started || this._resumed ? "PAUSE" : this._paused ? "START" : this._stopped && this._routineState == 'finished' ? "RESTART" : "START"}",
                              style:
                                  Theme.of(context).textTheme.display1.copyWith(
                                        fontSize: 18,
                                      ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: this._finishing
              ? Theme.of(context).primaryColor//Colors.black
              : (routine.state == 'NONE' ||
                      routine.state == 'restarted' ||
                      false) //routine.state == 'finished')
                  ? Colors.white10 //Colors.tealAccent
                  : Theme.of(context).primaryColor,// Colors.black,
          shape: BoxShape.circle,
          //border: Border.all(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    @required this.timeLeftPainter,
    this.backgroundColor,
    this.timeColor,
    this.roundsColor,
    this.setsColor,
  });

  final int timeLeftPainter;
  final Color backgroundColor, timeColor, roundsColor, setsColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintTimer = Paint()
      ..color = backgroundColor
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Dibujo círculo base
    (routine.state == 'NONE' ||
            routine.state == 'restarted' ||
            false) //routine.state == 'finished')
        ? paintTimer.color = Colors.black
        : paintTimer.color = backgroundColor;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paintTimer);
    /*canvas.drawRect(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height),
        paintTimer);*/

    // Dibujo progreso del tiempo
    double timeProgress = (1.0 -
        this.timeLeftPainter /
            (routine.state == 'work'
                ? routine.workTime
                : routine.state == 'rest'
                    ? routine.restTime
                    : routine.state == 'restBtwnSets'
                        ? routine.restBtwnSetsTime
                        : routine.state == 'init' ||
                                routine.state == 'NONE' ||
                                routine.state == 'restarted'
                            ? routine.initialPrepareTime
                            : routine
                                .workTime)); // Si es 'finish' o 'NONE' se asume que el tiempo a contar luego será de 'work'

    double timeAngle = timeProgress * 2 * math.pi;
    paintTimer.color = timeColor;
    // Si quisiera que se fuera llenando tipo una torta los segundos
    //paintTimer.style = PaintingStyle.fill;
    //paint.strokeWidth = 5.0;
    /*canvas.drawArc(
        Offset.zero & size, math.pi * 1.5, timeAngle, true, paintTimer);*/
    canvas.drawArc(
        Offset.zero & size, math.pi * 1.5, timeAngle, false, paintTimer);

    // Dibujo progreso Rounds y Sets
    Paint paintRoundSet = Paint()
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double roundProgress = (false /*routine.state == 'finished'*/ ||
                routine.state == 'restarted' ||
                routine.state == 'NONE'
            ? 0
            : routine.state == 'finished'
                ? routine.actualRound
                : routine.actualRound - 1) /
        routine
            .totalRounds; // 'actualRound - 1' para que arranque en 0 el progreso
    // el 'if' es pa que en 'finished' y 'restarted' se borren //UPD: en finish voy a dejar que se vea el circulo completo
    double roundAngle = roundProgress * 2 * math.pi;

    if (routine.totalSets > 1) {
      double setAngle = (false /*routine.state == 'finished'*/ ||
                  routine.state == 'restarted' ||
                  routine.state == 'NONE'
              ? 0
              : routine.state == 'finished'
                  ? routine.actualSet
                  : routine.actualSet - 1) /
          routine.totalSets *
          2 *
          math.pi;
      // Le tuve que poner Offset distinto de 0, porque sino quedaba corrido,
      // No entendí del todo, lo obtuve un toque a prueba y error,
      // pero teniendo en cuenta el tema del ancho del paintStroke
      paintRoundSet.color = setsColor;
      canvas.drawArc(
        Offset(-4 * paintRoundSet.strokeWidth / 2,
                -4 * paintRoundSet.strokeWidth / 2) &
            Size(size.width + 4 * paintRoundSet.strokeWidth,
                size.height + 4 * paintRoundSet.strokeWidth),
        math.pi * 1.5,
        setAngle,
        false,
        paintRoundSet,
      );
    }

    paintRoundSet.color = roundsColor;
    /*canvas.drawArc(
        Offset(-paintTimer.strokeWidth/2, -paintTimer.strokeWidth / 2) &
            Size(size.width + paintTimer.strokeWidth,
                size.height + paintTimer.strokeWidth),
        math.pi * 1.5,
        roundAngle,
        false,
        paintRoundSet);*/
    canvas.drawArc(
      Offset(-2 * paintRoundSet.strokeWidth / 2,
              -2 * paintRoundSet.strokeWidth / 2) &
          Size(size.width + 2 * paintRoundSet.strokeWidth,
              size.height + 2 * paintRoundSet.strokeWidth),
      math.pi * 1.5,
      roundAngle,
      false,
      paintRoundSet,
    );
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return timeLeftPainter != old.timeLeftPainter ||
        timeColor != old.timeColor ||
        backgroundColor != old.backgroundColor;
  }
}
