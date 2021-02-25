import 'package:flutter/material.dart';
import 'package:titan_timer_control/view/widgets/bluetooth/connect_bt.dart';
import 'package:titan_timer_control/view/widgets/control/control.dart';
import 'package:video_player/video_player.dart';

// Statefull por el video de Background
class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/gym_video4.mp4");

    _controller.addListener(() => setState(() {}));
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  // didChangeDep... para poder tener acceso al context y usar el Provider de Cronometro
  // Y realizo un 'scan' al iniciar esta pantalla (igual no sirve si el cronometr estaba apagado al iniciar)
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final cronometroBT = Provider.of<CronometroBluetooth>(context);
  //   cronometroBT.btScan();
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Control", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [BtDevicesWidget()],
      ),
      body: Stack(
        children: [
          // Video de fondo
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: _controller.value.size?.width ?? 0,
                height: _controller.value.size?.height ?? 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Align(child: ControlCard(), alignment: Alignment.bottomCenter),
        ],
      ),
    );
  }
}
