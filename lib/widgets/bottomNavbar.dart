import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget implements PreferredSizeWidget {
  BottomNavbar({Key key, this.tabName})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final String tabName;

  @override
  final Size preferredSize; // default is 56.0

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.green,
      shape: const CircularNotchedRectangle(),
      child: Container(
        height: 60.0,
      ),
    );
  }
}
