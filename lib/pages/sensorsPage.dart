import 'package:flutter/material.dart';
import 'package:project4_front_end/apis/box_api.dart';
import 'package:project4_front_end/models/box.dart';
import 'package:project4_front_end/models/measurement.dart';
import 'package:project4_front_end/pages/graphPage.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';
import 'package:project4_front_end/widgets/navbar.dart';

class Sensors extends StatefulWidget {
  final int id;
  final String token;
  Sensors(this.id, this.token);

  @override
  State<StatefulWidget> createState() => _SensorsState(id, token);
}

class _SensorsState extends State {
  int id;
  String token;
  _SensorsState(this.id, this.token);

  int _selectedIndex;
  int count = 0;
  Box box;
  String boxName = "";
  Measurement measurement;

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getSensors();
  }

  getSensors() async {
    BoxApi.getBoxesSensorMeasurements(id, token).then((result) {
      // call the api to fetch the user data
      setState(() {
        box = result;
        count = box.sensorBoxes.length;
        boxName = box.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: Navbar(tabName: '$boxName'),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: _sensorList(),
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

  _sensorList() {
    if (box == null) {
      // show a ProgressIndicator as long as there's no map info
      return Center(child: CircularProgressIndicator());
    } else if (box.sensorBoxes.isEmpty) {
      return Center(
        child: Text(
          "Geen Sensoren gevonden!",
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          if (this.box.sensorBoxes[position].measurements.isNotEmpty) {
            measurement = this.box.sensorBoxes[position].measurements.last;
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
                          child: Text((position + 1).toString(),
                              style: TextStyle(color: Colors.black)),
                        ),
                      ]),
                  title: Text(this.box.sensorBoxes[position].sensor.name),
                  subtitle: Column(
                    children: [
                      if (this
                          .box
                          .sensorBoxes[position]
                          .measurements
                          .isNotEmpty)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(this
                                    .box
                                    .sensorBoxes[position]
                                    .sensor
                                    .sensorType
                                    .name +
                                ": " +
                                measurement.value +
                                " " +
                                this
                                    .box
                                    .sensorBoxes[position]
                                    .sensor
                                    .sensorType
                                    .unit)),
                      if (this.box.sensorBoxes[position].measurements.isEmpty)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Geen meting")),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    if (this
                        .box
                        .sensorBoxes[position]
                        .measurements
                        .isNotEmpty) {
                      _showGraphPage(
                          this.box.sensorBoxes[position].sensor.id, token);
                    }
                  },
                ),
              ),
            ),
          ]);
        },
      );
    }
  }

  void _showGraphPage(int id, String token) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GraphPage(id, token)),
    );
    if (result == true) {
      getSensors();
    }
  }
}
