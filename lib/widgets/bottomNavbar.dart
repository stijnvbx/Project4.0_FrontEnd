import 'package:flutter/material.dart';
import 'package:project4_front_end/pages/home.dart';
import 'package:project4_front_end/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBarItem {
  IconData icon;

  CustomAppBarItem({this.icon});
}

class CustomBottomAppBar extends StatefulWidget {
  final ValueChanged<int> onTabSelected;
  final List<CustomAppBarItem> items;

  CustomBottomAppBar({this.onTabSelected, this.items}) {
    assert(this.items.length == 0 || this.items.length == 2 || this.items.length == 4);
  }

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getSelectedIndex();
  }

  void _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        setSelectedIndex(_selectedIndex);
        print("login");
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (_) => false);
      } else if (_selectedIndex == 1) {
        setSelectedIndex(_selectedIndex);
        print("graph");
      } else if (_selectedIndex == 2) {
        setSelectedIndex(_selectedIndex);
        print("info");
      } else {
        print("register");
        setSelectedIndex(_selectedIndex);
        Navigator.pushNamedAndRemoveUntil(
            context, Profile.routeName, (_) => false);
      }
    });
  }

  setSelectedIndex(int selectedIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', selectedIndex);
  }

  getSelectedIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('selectedIndex');
      print("test: " + _selectedIndex.toString());
    });
  }

  Widget _buildTabIcon(
      {int index, CustomAppBarItem item, ValueChanged<int> onPressed}) {
    return Expanded(
        child: SizedBox(
      height: 60.0,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => onPressed(index),
          child: Icon(
            item.icon,
            color: _selectedIndex == index ? Color(0xFF320331) : Colors.white,
            size: 24.0,
          ),
        ),
      ),
    ));
  }

  Widget _buildMiddleSeperator() {
    return Expanded(
      child: SizedBox(
        height: 60.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabIcon(
          index: index, item: widget.items[index], onPressed: _updateIndex);
    });
    items.insert(items.length >> 1, _buildMiddleSeperator());

    return BottomAppBar(
      child: Container(
        height: 60.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
        ),
      ),
      shape: CircularNotchedRectangle(),
      color: Theme.of(context).primaryColor,
    );
  }
}
