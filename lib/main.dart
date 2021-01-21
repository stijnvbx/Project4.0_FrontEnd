import 'package:flutter/material.dart';
import 'package:project4_front_end/pages/login.dart';
import 'package:project4_front_end/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  //HttpOverrides.global = new MyHttpOverrides();
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
    setSelectedIndex(0);
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
      },
    );
  }

  setSelectedIndex(int selectedIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', selectedIndex);
  }
}
