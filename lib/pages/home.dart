import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:project4_front_end/apis/box_user_api.dart';
import 'package:project4_front_end/models/box_user.dart';
import 'package:project4_front_end/models/location.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';
import 'package:project4_front_end/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State {
  List<BoxUser> boxList;
  int count = 0;
  int userID;
  List<String> location = [];
  Location currentLocation;
  BoxUser boxUser;

  @override
  void initState() {
    super.initState();
    _getBoxes();
  }

  int _selectedIndex;

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _getBoxes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getInt('userID');
    print(userID);
    await BoxUserApi.getBoxUserWithUserId(userID).then((result) {
      setState(() {
        boxList = result;
        count = boxList.length;
      });
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
          CustomAppBarItem(icon: Icons.add_alert),
          CustomAppBarItem(icon: Icons.person),
        ],
      ),
    );
  }

  _boxListItems() {
    if (boxList == null) {
      // show a ProgressIndicator as long as there's no map info
      return Center(child: CircularProgressIndicator());
    } else if (boxList.isEmpty) {
      return Center(
        child: Text(
          "Geen boxen gevonden!",
          textAlign: TextAlign.center,
        ),
      );
    } else {      
      return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {

          var lat = this.boxList[position].locations[0].latitude;
          var long = this.boxList[position].locations[0].longitude;
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text((position + 1)
                          .toString()), // Show the first two leter of the map name
                    ),
                  ]),
              title: Text(this.boxList[position].box.name),
              subtitle: Column(
                children: [
                  if (this.boxList[position].locations[0].latitude != null)
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(getCoordinats(position, lat, long))),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                debugPrint("Tapped on myMapId: " +
                    this.boxList[position].id.toString());
                print("Navigate to Sensors");
              },
            ),
          );
        },
      );
    }
  }

  String getCoordinats(i, double lat, double long) {
    _getCoordinats(lat, long);

    if (location.isEmpty) {
      return "";
    } else {
      return location[i];
    }
  }

  _getCoordinats(double lat, double long) async {
    var addresses = await Geocoder.local
        .findAddressesFromCoordinates(new Coordinates(lat, long));
    var first = addresses.first;
    //print("${first.adminArea} : ${first.addressLine} : ${first.countryCode} : ${first.countryName} : ${first.locality} : ${first.postalCode} : ${first.subAdminArea} : ${first.subThoroughfare} : ${first.thoroughfare}");
    setState(() {
      location.add("${first.addressLine}");
    });
  }
}
