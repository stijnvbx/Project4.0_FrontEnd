//Layout
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project4_front_end/apis/measurement_api.dart';
import 'package:project4_front_end/models/measurement.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';
import 'package:project4_front_end/widgets/navbar.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphPage extends StatefulWidget {
  final int id;
  final String token;
  GraphPage(this.id, this.token);

  State<StatefulWidget> createState() => _GraphPage(id, token);
}

class Temp {
  double timestamp;
  double temperature;

  Temp(this.timestamp, this.temperature);
}

class _GraphPage extends State {
  int id;
  String token;
  _GraphPage(this.id, this.token);
  int _selectedIndex;
  List<Measurement> tempList;
  //List<package.LineChartModel> dataList = [];
  List<charts.Series<Temp, double>> _seriesDayData;
  List<charts.Series<Temp, double>> _seriesWeekData;
  List<charts.Series<Temp, double>> _seriesMonthData;

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDayTempList();
    _getWeekTempList();
    _getMonthTempList();
    _seriesDayData = List<charts.Series<Temp, double>>();
    _seriesWeekData = List<charts.Series<Temp, double>>();
    _seriesMonthData = List<charts.Series<Temp, double>>();
  }

  _getDayTempList() {
    MeasurementApi.getMeasurementsFromSensor(id, token).then((result) {
      setState(() {
        tempList = result;
        var lineAirTempData = <Temp>[];
        for (Measurement m in tempList) {
          String nowYear = DateTime.now().year.toString();
          String nowMonth = DateTime.now().month.toString();
          String nowDay = DateTime.now().day.toString();
          String year = m.timestamp.split('T')[0].split('-')[0];
          String month = m.timestamp.split('T')[0].split('-')[1];
          String day = m.timestamp.split('T')[0].split('-')[2];
          String hour = m.timestamp.split('T')[1].split(':')[0];
          if (month.length < 2) {
            month = "0" + month;
          }
          if (day.length < 2) {
            day = "0" + day;
          }
          if (nowYear == year && nowMonth == month && nowDay == day) {
            lineAirTempData
                .add(new Temp(double.parse(hour), double.parse(m.value)));
          }
        }

        _seriesDayData.add(
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

  _getWeekTempList() {
    MeasurementApi.getMeasurementsFromSensor(id, token).then((result) {
      setState(() {
        tempList = result;
        var lineAirTempData = <Temp>[];
        for (Measurement m in tempList) {
          String nowYear = DateTime.now().year.toString();
          String nowMonth = DateTime.now().month.toString();
          String nowDay = DateTime.now().day.toString();
          String year = m.timestamp.split('T')[0].split('-')[0];
          String month = m.timestamp.split('T')[0].split('-')[1];
          String day = m.timestamp.split('T')[0].split('-')[2];
          if (month.length < 2) {
            month = "0" + month;
          }
          if (day.length < 2) {
            day = "0" + day;
          }
          if (nowYear == year && nowMonth == month && nowDay == day) {
            lineAirTempData
                .add(new Temp(double.parse(day), double.parse(m.value)));
          }
        }

        _seriesWeekData.add(
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

  _getMonthTempList() {
    MeasurementApi.getMeasurementsFromSensor(id, token).then((result) {
      setState(() {
        tempList = result;
        var lineAirTempData = <Temp>[];
        for (Measurement m in tempList) {
          String nowYear = DateTime.now().year.toString();
          String nowMonth = DateTime.now().month.toString();
          String year = m.timestamp.split('T')[0].split('-')[0];
          String month = m.timestamp.split('T')[0].split('-')[1];
          String day = m.timestamp.split('T')[0].split('-')[2];
          if (month.length < 2) {
            month = "0" + month;
          }
          if (nowYear == year && nowMonth == month) {
            lineAirTempData
                .add(new Temp(double.parse(day), double.parse(m.value)));
          }
        }

        _seriesMonthData.add(
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
      body: Container(
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
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.dailymotion),
                ),
                Tab(icon: Icon(FontAwesomeIcons.wordpress)),
                Tab(icon: Icon(FontAwesomeIcons.maxcdn)),
              ],
            ),
            title: Text('Omgevingstemperatuur'),
          ),
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
                          child: charts.LineChart(_seriesDayData,
                              defaultRenderer: new charts.LineRendererConfig(
                                  includeArea: false, stacked: false),
                              animate: true,
                              animationDuration: Duration(seconds: 1),
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
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Temperaturen van deze week',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: charts.LineChart(_seriesWeekData,
                              defaultRenderer: new charts.LineRendererConfig(
                                  includeArea: false, stacked: false),
                              animate: true,
                              animationDuration: Duration(seconds: 1),
                              behaviors: [
                                new charts.ChartTitle('Dag van de week',
                                    behaviorPosition:
                                        charts.BehaviorPosition.bottom,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                                new charts.ChartTitle('Temperatuur in °C',
                                    behaviorPosition:
                                        charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Temperaturen van deze maand',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: charts.LineChart(_seriesMonthData,
                              defaultRenderer: new charts.LineRendererConfig(
                                  includeArea: false, stacked: false),
                              animate: true,
                              animationDuration: Duration(seconds: 1),
                              behaviors: [
                                new charts.ChartTitle('Dag van de maand',
                                    behaviorPosition:
                                        charts.BehaviorPosition.bottom,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                                new charts.ChartTitle('Temperatuur in °C',
                                    behaviorPosition:
                                        charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
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
      );
    }
  }
}
