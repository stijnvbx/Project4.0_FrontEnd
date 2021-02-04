import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:project4_front_end/apis/box_user_api.dart';
import 'package:project4_front_end/models/box_user.dart';
import 'package:project4_front_end/models/location.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';
import 'package:project4_front_end/widgets/navbar.dart';
import 'package:project4_front_end/pages/sensorsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State {
  List<BoxUser> boxList = [];
  int count = 0;
  List<int> differentBoxes = [];
  int userID;
  String token;
  String userTypeName;
  List<String> locations = [];
  Location currentLocation;
  BoxUser boxUser;
  List<Location> currentLocations = [];

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
    token = prefs.getString('token');
    userTypeName = prefs.getString('userTypeName');
    print(userID);
    print(token);
    print(userTypeName);
    if (userTypeName == "Monteur") {
      print("test");
      BoxUserApi.getBoxUsers(token).then((result) {
        setState(() {
          for (int i = 0; i < result.length; i++) {
            if (!differentBoxes.contains(result[i].boxID)) {
              differentBoxes.add(result[i].boxID);
              boxList.add(result[i]);
              print(differentBoxes.length);
            }
          }
          count = boxList.length;
          /*if (boxList != null) {
            for (boxUser in boxList) {
              if (boxUser.locations.isNotEmpty) {
                for (currentLocation in boxUser.locations) {
                  if (currentLocation.endDate == null) {
                    currentLocations.add(currentLocation);
                  }
                }
              }
            }
          }*/
        });
      });
    } else {
      BoxUserApi.getBoxUserWithUserId(userID, token).then((result) {
        setState(() {
          boxList = result;
          count = boxList.length;
          if (boxList != null) {
            for (boxUser in boxList) {
              if (boxUser.locations.isNotEmpty) {
                for (currentLocation in boxUser.locations) {
                  if (currentLocation.endDate == null) {
                    currentLocations.add(currentLocation);
                  }
                }
              }
            }
          }
        });
      });
    }
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
          // CustomAppBarItem(icon: Icons.graphic_eq),
          // CustomAppBarItem(icon: Icons.add_alert),
          CustomAppBarItem(icon: Icons.person),
        ],
      ),
    );
  }

  _boxListItems() {
    if (boxList.isEmpty) {
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
          var lat = 0.0;
          var long = 0.0;
          if (this.boxList[position].locations.isNotEmpty &&
              currentLocations.isNotEmpty) {
            lat = currentLocations[position].latitude;
            long = currentLocations[position].longitude;
            _getCoordinats(lat, long);
          }
          return Row(children: <Widget>[
            Flexible(
              child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text((position + 1).toString()),
                        ),
                      ]),
                  title: Text(this.boxList[position].box.name),
                  subtitle: Column(
                    children: [
                      if (locations.isNotEmpty)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(locations[position])),
                      if (locations.isEmpty)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('geen locatie')),
                      SizedBox(height: 5),
                      if (this.boxList[position].box.comment != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(this.boxList[position].box.comment)),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    debugPrint("Tapped on myMapId: " +
                        this.boxList[position].box.id.toString());
                    print("Navigate to Sensors");
                    _showSensors(this.boxList[position].box.id, token);
                  },
                ),
              ),
            ),
          ]);
        },
      );
    }
  }

  void _showSensors(int id, String token) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Sensors(id, token)),
    );
    if (result == true) {
      _getBoxes();
    }
  }

  _getCoordinats(double lat, double long) async {
    var addresses = await Geocoder.local
        .findAddressesFromCoordinates(new Coordinates(lat, long));
    var first = addresses.first;
    //print("${first.adminArea} : ${first.addressLine} : ${first.countryCode} : ${first.countryName} : ${first.locality} : ${first.postalCode} : ${first.subAdminArea} : ${first.subThoroughfare} : ${first.thoroughfare}");
    setState(() {
      locations.add("${first.addressLine}");
    });
  }
}
