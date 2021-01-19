import 'package:flutter/material.dart';
import 'package:project4_front_end/pages/login.dart';
import 'package:project4_front_end/pages/register.dart';

void main() {
  //HttpOverrides.global = new MyHttpOverrides();
  runApp(MyFlutterVitoApp());
}

class MyFlutterVitoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //clearUserID();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VITO',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
      routes: {
        Register.routeName: (_) => Register(),
      },
    );
  }

  // clearUserID() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('userID');
  // }
}