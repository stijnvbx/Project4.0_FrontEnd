//Layout
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project4_front_end/apis/measurement_api.dart';
import 'package:project4_front_end/models/measurement.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';
import 'package:project4_front_end/widgets/navbar.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphPage extends StatefulWidget {
  static const routeName = "/graphPage";

  State<StatefulWidget> createState() => _GraphPage();
}

class Temp {
  double timestamp;
  double temperature;

  Temp(this.timestamp, this.temperature);
}

class _GraphPage extends State {
  int _selectedIndex;
  List<Measurement> tempList;
  //List<package.LineChartModel> dataList = [];
  List<charts.Series<Temp, double>> _seriesLineData;

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTempList();
    _seriesLineData = List<charts.Series<Temp, double>>();
  }

  _getTempList() {
    MeasurementApi.getMeasurementsFromSensor(12).then((result) {
      setState(() {
        tempList = result;
        var lineAirTempData = <Temp>[];
        for (Measurement m in tempList) {
          String year = DateTime.now().year.toString();
          String month = DateTime.now().month.toString();
          String day = DateTime.now().day.toString();
          if (month.length < 2) {
            month = "0" + month;
          }
          if (day.length < 2) {
            day = "0" + day;
          }
          if (m.timestamp.split('T')[0].split('-')[0] == year &&
              m.timestamp.split('T')[0].split('-')[1] == month &&
              m.timestamp.split('T')[0].split('-')[2] == day) {
            print("Time" + m.timestamp.split('T')[1].split(':')[0].toString());
            print("Value" + m.value);
            lineAirTempData.add(new Temp(
                double.parse(m.timestamp.split('T')[1].split(':')[0] +
                    "." +
                    m.timestamp.split('T')[1].split(':')[1]),
                double.parse(m.value)));
          }
        }

        _seriesLineData.add(
          charts.Series(
            colorFn: (__, _) =>
                charts.ColorUtil.fromDartColor(Color(0xff990099)),
            id: 'Lucht',
            data: lineAirTempData,
            domainFn: (Temp temperature, _) => temperature.timestamp,
            measureFn: (Temp temperature, _) => temperature.temperature,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(tabName: 'Temperatuur van de lucht'),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: _tempListItems(),
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

  _tempListItems() {
    if (tempList == null) {
      // show a ProgressIndicator as long as there's no map info
      return Center(child: CircularProgressIndicator());
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 1,
          child: Scaffold(
            body: TabBarView(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Temperaturen van vandaag',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: charts.LineChart(_seriesLineData,
                                defaultRenderer: new charts.LineRendererConfig(
                                    includeArea: false, stacked: false),
                                animate: true,
                                animationDuration: Duration(seconds: 3),
                                behaviors: [
                                  new charts.ChartTitle('Uur van de dag',
                                      behaviorPosition:
                                          charts.BehaviorPosition.bottom,
                                      titleOutsideJustification: charts
                                          .OutsideJustification.middleDrawArea),
                                  new charts.ChartTitle('Temperatuur in °C',
                                      behaviorPosition:
                                          charts.BehaviorPosition.start,
                                      titleOutsideJustification: charts
                                          .OutsideJustification.middleDrawArea),
                                  new charts.SeriesLegend()
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
