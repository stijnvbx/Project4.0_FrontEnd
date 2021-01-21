import 'package:flutter/material.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';
import 'package:project4_front_end/widgets/navbar.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State {
  List<String> boxList = ["box1", "box2", "box3", "box4", "box5", "box6", "box7", "box8"];
  int count = 0;
  int userID;
  //User user = User();
  //UserMapData userMapData;
  List maxScoreList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      count = boxList.length;
    });
  }

  int _selectedIndex = 0;

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(tabName: 'SensorBoxen'),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: _boxListItems(),
        //change margin from bottom so that the cards are visible
        margin: EdgeInsets.only(bottom: 37),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: null,
            child: CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage("assets/logo.png"),
            ),
            elevation: 2.0,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(
        onTabSelected: _selectedTab,
        items: [
          CustomAppBarItem(icon: Icons.home),
          CustomAppBarItem(icon: Icons.graphic_eq),
          CustomAppBarItem(icon: Icons.info),
          CustomAppBarItem(icon: Icons.person),
        ],
      ),
    );
  }

  _boxListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text((position+1).toString()), // Show the first two leter of the map name
                  ),
                ]),
            title: Text(this.boxList[position]),
            subtitle: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                      // Text(
                      //     "Items: " + 0.toString() + "/" + this.mapList[position].maxItems.toString()),
                      Text("Location: " +
                          this.boxList[position]),
                ),
              ],
            ),
            isThreeLine: true,
            onTap: () {
              debugPrint("Tapped on myMapId: " +
                  this.boxList[position]);
              print("Navigate to home");
            },
          ),
        );
      },
    );
  }
}
