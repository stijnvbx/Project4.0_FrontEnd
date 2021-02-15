import 'package:flutter/material.dart';
import 'package:project4_front_end/pages/home.dart';
import 'package:project4_front_end/pages/login.dart';
import 'package:project4_front_end/pages/profile.dart';

void main() {
  runApp(MyFlutterVitoApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

class MyFlutterVitoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFF81BB26, color);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VITO',
      theme: ThemeData(
        primarySwatch: colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
      routes: {
        Profile.routeName: (_) => Profile(),
        HomePage.routeName: (_) => HomePage(),
      },
    );
  }
}
