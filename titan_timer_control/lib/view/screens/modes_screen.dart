import 'package:flutter/material.dart';
import 'package:titan_timer_control/constants.dart';

class ModesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _titleStyle = TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700);

    return Scaffold(
      // appBar: AppBar(title: Text("Modos de entrenamiento")),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Container(
            height: _size.height * 0.45,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(40)
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Selecciona el modo de trabajo", style: _titleStyle),
                  Divider(height: 24),
                  Column(
                    children: [
                      ModeTab(name: "amrap"),
                      ModeTab(name: "hiit"),
                      ModeTab(name: "tabata"),
                      ModeTab(name: "combate"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModeTab extends StatelessWidget {
  ModeTab({@required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return SizedBox(
      width: _size.width,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListTile(
              title: Text(
                name.toUpperCase(),
                style: TextStyle(fontSize: 24),
              ),
              subtitle: Text("Some description..."),
              trailing: Icon(Icons.work),
            ),
          ),
        ),
      ),
    );
  }
}
