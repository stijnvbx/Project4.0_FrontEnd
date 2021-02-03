//Layout
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project4_front_end/apis/measurement_api.dart';
import 'package:project4_front_end/models/measurement.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:week_of_year/week_of_year.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatefulWidget {
  final int id;
  final String token;
  GraphPage(this.id, this.token);

  State<StatefulWidget> createState() => _GraphPage(id, token);
}

class Temp {
  int timestamp;
  double value;

  Temp(this.timestamp, this.value);
}

class _GraphPage extends State {
  int id;
  String token;
  _GraphPage(this.id, this.token);
  int _selectedIndex;
  List<Measurement> valList;
  //List<package.LineChartModel> dataList = [];
  List<charts.Series<Temp, int>> _seriesDayData = [];
  List<charts.Series<Temp, int>> _seriesWeekData = [];
  List<charts.Series<Temp, int>> _seriesMonthData = [];

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
  }

  _getDayTempList() {
    MeasurementApi.getMeasurementsFromSensor(id, token).then((result) {
      setState(() {
        valList = result;
        int counter = 0;
        var lineDayData = <Temp>[];
        List<Temp> perHourList = [];
        for (Measurement m in valList) {
          counter++;
          String today = DateFormat("yyyy-MM-DD").format(DateTime.now());
          String measurementDate =
              DateFormat("yyyy-MM-DD").format(DateTime.parse(m.timestamp));
          String hour = m.timestamp.split('T')[1].split(':')[0];

          if (today == measurementDate) {
            if (perHourList.isEmpty) {
              perHourList.add(new Temp(int.parse(hour), double.parse(m.value)));
            } else if (int.parse(hour) == perHourList.last.timestamp) {
              perHourList.add(new Temp(int.parse(hour), double.parse(m.value)));
            } else {
              double value = 0.0;
              for (Temp t in perHourList) {
                value += t.value;
              }
              value /= perHourList.length;
              perHourList.clear();
              lineDayData.add(new Temp(int.parse(hour), value));
              perHourList.add(new Temp(int.parse(hour), double.parse(m.value)));
            }
            if (valList.length == counter) {
              double value = 0.0;
              for (Temp t in perHourList) {
                value += t.value;
              }
              value /= perHourList.length;
              perHourList.clear();
              lineDayData.add(new Temp(int.parse(hour), value));
            }
            lineDayData.add(new Temp(int.parse(hour), double.parse(m.value)));
          }
        }

        if (lineDayData.isNotEmpty) {
          _seriesDayData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff990099)),
              id: 'Lucht',
              data: lineDayData,
              domainFn: (Temp temperature, _) => temperature.timestamp,
              measureFn: (Temp temperature, _) => temperature.value,
            ),
          );
        }
      });
    });
  }

  _getWeekTempList() {
    MeasurementApi.getMeasurementsFromSensor(id, token).then((result) {
      setState(() {
        valList = result;
        List<Temp> perDayList = [];
        List<Temp> perNightList = [];

        var lineDayTempData = <Temp>[];
        var lineNightTempData = <Temp>[];
        int counter = 0;

        for (Measurement m in valList) {
          counter++;
          DateTime today = DateTime.now();
          DateTime measurementDate = DateTime.parse(m.timestamp);
          String measurementDay = m.timestamp.split('T')[0].split('-')[2];
          String day = m.timestamp.split('T')[0].split('-')[2];
          int hour = int.parse(m.timestamp.split('T')[1].split(':')[0]);

          if (measurementDate.weekOfYear == today.weekOfYear) {
            if (hour >= 6 && hour <= 18) {
              if (perDayList.isEmpty) {
                perDayList.add(new Temp(int.parse(day), double.parse(m.value)));
              } else if (int.parse(day) == perDayList.last.timestamp) {
                perDayList.add(new Temp(int.parse(day), double.parse(m.value)));
              } else {
                double value = 0.0;
                for (Temp t in perDayList) {
                  value += t.value;
                }
                value /= perDayList.length;
                perDayList.clear();
                lineDayTempData.add(new Temp(int.parse(day), value));
                perDayList.add(new Temp(int.parse(day), double.parse(m.value)));
              }
              if (valList.length == counter) {
                double value = 0.0;
                for (Temp t in perDayList) {
                  value += t.value;
                }
                value /= perDayList.length;
                perDayList.clear();
                lineDayTempData.add(new Temp(int.parse(day), value));
              }
            }

            //Nacht
            else {
              if (perNightList.isEmpty) {
                perNightList
                    .add(new Temp(int.parse(day), double.parse(m.value)));
              } else if (int.parse(day) == perNightList.last.timestamp) {
                perNightList
                    .add(new Temp(int.parse(day), double.parse(m.value)));
              } else {
                double value = 0.0;
                for (Temp t in perNightList) {
                  value += t.value;
                }
                value /= perNightList.length;
                perNightList.clear();
                lineNightTempData.add(new Temp(int.parse(day), value));
                perNightList
                    .add(new Temp(int.parse(day), double.parse(m.value)));
              }
              if (valList.length == counter) {
                double value = 0.0;
                for (Temp t in perNightList) {
                  value += t.value;
                }
                value /= perNightList.length;
                perNightList.clear();
                lineNightTempData.add(new Temp(int.parse(day), value));
              }
            }
          }
        }
        if (lineDayTempData.isNotEmpty) {
          _seriesWeekData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff990011)),
              id: 'Dag',
              data: lineDayTempData,
              domainFn: (Temp temperature, _) => temperature.timestamp,
              measureFn: (Temp temperature, _) => temperature.value,
            ),
          );
        }

        if (lineNightTempData.isNotEmpty) {
          _seriesWeekData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff056050)),
              id: 'Nacht',
              data: lineDayTempData,
              domainFn: (Temp temperature, _) => temperature.timestamp,
              measureFn: (Temp temperature, _) => temperature.value,
            ),
          );
        }
      });
    });
  }

  _getMonthTempList() {
    MeasurementApi.getMeasurementsFromSensor(id, token).then((result) {
      setState(() {
        valList = result;
        List<Temp> perDayList = [];
        List<Temp> perNightList = [];

        var lineDayTempData = <Temp>[];
        var lineNightTempData = <Temp>[];
        int counter = 0;
        for (Measurement m in valList) {
          counter++;
          String thisMonth = DateFormat("yyyy-MM").format(DateTime.now());
          String measurementMonth =
              DateFormat("yyyy-MM").format(DateTime.parse(m.timestamp));
          String day = m.timestamp.split('T')[0].split('-')[2];
          int hour = int.parse(m.timestamp.split('T')[1].split(':')[0]);

          if (thisMonth == measurementMonth) {
            //DAG
            //print("day: " + int.parse(day).toString());
            //print("measure day: " + perDayList.last.timestamp.toString());
            if (hour >= 6 && hour <= 18) {
              if (perDayList.isEmpty) {
                perDayList.add(new Temp(int.parse(day), double.parse(m.value)));
              } else if (int.parse(day) == perDayList.last.timestamp) {
                perDayList.add(new Temp(int.parse(day), double.parse(m.value)));
              } else {
                double value = 0.0;
                for (Temp t in perDayList) {
                  value += t.value;
                }
                value /= perDayList.length;
                perDayList.clear();
                lineDayTempData.add(new Temp(int.parse(day), value));
                perDayList.add(new Temp(int.parse(day), double.parse(m.value)));
              }
              if (valList.length == counter) {
                double value = 0.0;
                for (Temp t in perDayList) {
                  value += t.value;
                }
                value /= perDayList.length;
                perDayList.clear();
                lineDayTempData.add(new Temp(int.parse(day), value));
              }
            }

            //Nacht
            else {
              if (perNightList.isEmpty) {
                perNightList
                    .add(new Temp(int.parse(day), double.parse(m.value)));
              } else if (int.parse(day) == perNightList.last.timestamp) {
                perNightList
                    .add(new Temp(int.parse(day), double.parse(m.value)));
              } else {
                double value = 0.0;
                for (Temp t in perNightList) {
                  value += t.value;
                }
                value /= perNightList.length;
                perNightList.clear();
                lineNightTempData.add(new Temp(int.parse(day), value));
                perNightList
                    .add(new Temp(int.parse(day), double.parse(m.value)));
              }
              if (valList.length == counter) {
                double value = 0.0;
                for (Temp t in perNightList) {
                  value += t.value;
                }
                value /= perNightList.length;
                perNightList.clear();
                lineNightTempData.add(new Temp(int.parse(day), value));
              }
            }
          }
          // for (Temp l in lineDayTempData) {
          //   print("Dag lijst: " + l.value.toString());
          // }

          if (lineDayTempData.isNotEmpty) {
            _seriesMonthData.add(
              charts.Series(
                colorFn: (__, _) =>
                    charts.ColorUtil.fromDartColor(Color(0xff990011)),
                id: 'Dag',
                data: lineDayTempData,
                domainFn: (Temp temperature, _) => temperature.timestamp,
                measureFn: (Temp temperature, _) => temperature.value,
              ),
            );
          }
          if (lineNightTempData.isNotEmpty) {
            _seriesMonthData.add(
              charts.Series(
                colorFn: (__, _) =>
                    charts.ColorUtil.fromDartColor(Color(0xff056050)),
                id: 'Nacht',
                data: lineNightTempData,
                domainFn: (Temp temperature, _) => temperature.timestamp,
                measureFn: (Temp temperature, _) => temperature.value,
              ),
            );
          }
        }
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
          // CustomAppBarItem(icon: Icons.graphic_eq),
          // CustomAppBarItem(icon: Icons.add_alert),
          CustomAppBarItem(icon: Icons.person),
        ],
      ),
    );
  }

  _tempListItems() {
    if (valList == null) {
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
                        if (_seriesDayData.isEmpty)
                          Text(
                            'Nog geen temperaturen vandaag',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        if (_seriesDayData.isNotEmpty)
                          Text(
                            'Temperaturen van vandaag',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        if (_seriesDayData.isNotEmpty)
                          Expanded(
                            child: charts.LineChart(
                              _seriesDayData,
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
                              ],
                              domainAxis: new charts.NumericAxisSpec(
                                  viewport: new charts.NumericExtents(0, 24),
                                  tickProviderSpec:
                                      new charts.BasicNumericTickProviderSpec(
                                          zeroBound: true,
                                          desiredMinTickCount: 12,
                                          desiredMaxTickCount: 24)),
                              primaryMeasureAxis: new charts.NumericAxisSpec(
                                  tickProviderSpec:
                                      new charts.BasicNumericTickProviderSpec(
                                zeroBound: true,
                                desiredMinTickCount: 10,
                                desiredMaxTickCount: 20,
                              )),
                            ),
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
                        if (_seriesWeekData.isEmpty)
                          Text(
                            'Nog geen temperaturen deze week',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        if (_seriesWeekData.isNotEmpty)
                          Text(
                            'Temperaturen van deze week',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        if (_seriesWeekData.isNotEmpty)
                          Expanded(
                            child: charts.LineChart(
                              _seriesWeekData,
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
                              ],
                              domainAxis: new charts.NumericAxisSpec(
                                  viewport: new charts.NumericExtents(1, 7),
                                  tickProviderSpec:
                                      new charts.BasicNumericTickProviderSpec(
                                    zeroBound: true,
                                    desiredTickCount: 14,
                                  )),
                              primaryMeasureAxis: new charts.NumericAxisSpec(
                                  tickProviderSpec:
                                      new charts.BasicNumericTickProviderSpec(
                                zeroBound: true,
                                desiredTickCount: 7,
                              )),
                            ),
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
                        if (_seriesMonthData.isEmpty)
                          Text(
                            'Nog geen temperaturen deze maand',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        if (_seriesMonthData.isNotEmpty)
                          Text(
                            'Temperaturen van deze maand',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        if (_seriesMonthData.isNotEmpty)
                          Expanded(
                            child: charts.LineChart(
                              _seriesMonthData,
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
                              ],
                              domainAxis: new charts.NumericAxisSpec(
                                  viewport: new charts.NumericExtents(1, 31),
                                  tickProviderSpec:
                                      new charts.BasicNumericTickProviderSpec(
                                          zeroBound: true,
                                          desiredTickCount: 32)),
                              primaryMeasureAxis: new charts.NumericAxisSpec(
                                  tickProviderSpec:
                                      new charts.BasicNumericTickProviderSpec(
                                zeroBound: true,
                                desiredMinTickCount: 10,
                                desiredMaxTickCount: 20,
                              )),
                            ),
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
