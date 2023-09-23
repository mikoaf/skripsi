import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Home_ extends StatelessWidget {
  const Home_({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //body: Center(child: Column(children: [Text('apaya')],),)
        body: Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Color.fromARGB(10, 50, 100, 200)),
            height: 100,
            width: 100,
            child: Text('hai'),
          ),
          Container(
            decoration: BoxDecoration(color: Color.fromARGB(255, 255, 20, 40)),
            height: 200,
          )
        ],
      ),
    ));
  }
}
