import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:timer_bt_0/widgets/BT_methods.dart';
import 'package:timer_bt_0/widgets/appThemes.dart';

class RoutineMode_Screen extends StatelessWidget {
  List<String> imagesSwiper = [
    'assets/mq/img12.jpg',
    'assets/mq/img13.jpg',
    'assets/mq/img7.jpg',
  ];
  List<String> routineModes = ['amrap', 'tabata', 'fight'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modos de entrenamiento"),
        centerTitle: true,
        //backgroundColor: Color.fromARGB(0, 255, 255, 255),
        //backgroundColor: Colors.grey[850],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Text("AMRAP", style: TextStyle(fontSize: 18),),
            Expanded(
              child: Swiper(
                itemCount: 3, //imagesSwiper.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          //color: Colors.blue,
                          image: DecorationImage(
                              image: AssetImage(
                                imagesSwiper[index],
                              ),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(5, 5),
                                color: Color.fromARGB(100, 0, 0, 0),
                                blurRadius: 5)
                          ]),
                      /*child: Image.asset(
                        imagesSwiper[index],
                        fit: BoxFit.cover,
                      ),*/
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            routineModes[index].toUpperCase(), //routineModes[index][0].toUpperCase() + routineModes[index].substring(1),
                            style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white), //TextStyle(fontSize: 48, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.white, color: Colors.white54)),
                loop: false,
                //control: SwiperControl(),
                onTap: (index) {
                  //print("Seleccionó la rutina N°$index -> ${routineModes[index]}");
                  Navigator.of(context)
                      .pushNamed(
                    '/ConfigRoutine',
                    arguments: routineModes[index],
                  );
                },
              ),
            ),
            //FlatButton(onPressed: (){}, child: Text("OK"))
          ],
        ),
      ),
    );
  }
}
