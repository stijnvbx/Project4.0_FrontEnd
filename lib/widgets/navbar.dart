import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:project4_front_end/pages/profile.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  Navbar({Key key, this.tabName})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final String tabName;

  @override
  final Size preferredSize; // default is 56.0

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title:
          new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.tabName.toString()),
        FlatButton(
          onPressed: null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/logo_vito.jpg',
              height: 45.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ]),
    );
  }
}
