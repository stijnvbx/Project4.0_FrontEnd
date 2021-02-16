//Layout
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project4_front_end/apis/measurement_api.dart';
import 'package:project4_front_end/apis/sensor_api.dart';
import 'package:project4_front_end/models/measurement.dart';
import 'package:project4_front_end/models/sensor.dart';
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

class Value {
  int timestamp;
  double value;

  Value(this.timestamp, this.value);
}

class _GraphPage extends State {
  int id;
  String token;
  _GraphPage(this.id, this.token);
  int _selectedIndex;

  Sensor sensor;

  List<Measurement> valList;
  List<charts.Series<Value, int>> _seriesDayData;
  List<charts.Series<Value, int>> _seriesWeekData;
  List<charts.Series<Value, int>> _seriesMonthData;

  //Custom labels voor dagen van week in grafiek
  final customWeekFormatter = charts.BasicNumericTickFormatterSpec((num value) {
    if (value == 0) {
      return "Ma";
    } else if (value == 1) {
      return "Di";
    } else if (value == 2) {
      return "Wo";
    } else if (value == 3) {
      return "Do";
    } else if (value == 4) {
      return "Vr";
    } else if (value == 5) {
      return "Za";
    } else if (value == 6) {
      return "Zo";
    }
  });

  //Custom labels voor de dagen van de maand zodat deze bij nul beginnen te tellen maar de klant ziet het niet

  final customMonthFormatter =
      charts.BasicNumericTickFormatterSpec((num value) {
    value += 1;
    return value.toInt().toString();
  });

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSensorWithType();
    _getDayValList();
    _getWeekValList();
    _getMonthValList();
  }

  _getSensorWithType() {
    SensorApi.getSensor(id, token).then((result) {
      setState(() {
        sensor = result;
      });
    });
  }

  _getDayValList() {
    MeasurementApi.getMeasurementsFromSensor(id, token).then((result) {
      setState(() {
        _seriesDayData = [];
        valList = result;
        valList.sort((a, b) {
          return a.timestamp.compareTo(b.timestamp);
        });
        int counter = 0;
        var lineDayData = <Value>[];
        List<Value> perHourList = [];
        for (Measurement m in valList) {
          counter++;
          String today = DateFormat("yyyy-MM-DD").format(DateTime.now());
          String measurementDate =
              DateFormat("yyyy-MM-DD").format(DateTime.parse(m.timestamp));
          String hour = m.timestamp.split('T')[1].split(':')[0];

          if (today == measurementDate) {
            if (perHourList.isEmpty) {
              perHourList
                  .add(new Value(int.parse(hour), double.parse(m.value)));
            } else if (int.parse(hour) == perHourList.last.timestamp) {
              perHourList
                  .add(new Value(int.parse(hour), double.parse(m.value)));
            } else {
              double value = 0.0;
              for (Value t in perHourList) {
                value += t.value;
              }
              value /= perHourList.length;

              lineDayData.add(new Value(perHourList.last.timestamp, value));
              perHourList.clear();
              perHourList
                  .add(new Value(int.parse(hour), double.parse(m.value)));
            }

            if (valList.length == counter) {
              double value = 0.0;
              for (Value t in perHourList) {
                value += t.value;
              }
              value /= perHourList.length;
              lineDayData.add(new Value(perHourList.last.timestamp, value));
              perHourList.clear();
            }
          }
        }

        if (lineDayData.isNotEmpty) {
          _seriesDayData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff109618)),
              id: 'Meting',
              data: lineDayData,
              domainFn: (Value value, _) => value.timestamp,
              measureFn: (Value value, _) => value.value,
            ),
          );
        }
      });
    });
  }

  _getWeekValList() {
    MeasurementApi.getMeasurementsFromSensor(id, token).then((result) {
      setState(() {
        _seriesWeekData = [];
        valList = result;
        valList.sort((a, b) {
          return a.timestamp.compareTo(b.timestamp);
        });
        List<Value> perDayList = [];
        List<Value> perNightList = [];

        var lineDayValData = <Value>[];
        var lineNightValData = <Value>[];
        int counter = 0;

        for (Measurement m in valList) {
          counter++;
          var today = DateTime.now();
          var measurementDate = DateTime.parse(m.timestamp);
          Duration difference = today.difference(measurementDate);
          String day = m.timestamp.split('T')[0].split('-')[2];
          int hour = int.parse(m.timestamp.split('T')[1].split(':')[0]);

          if (difference.inDays <= 7 && measurementDate.isBefore(today)) {
            if (hour >= 6 && hour <= 18) {
              if (perDayList.isEmpty) {
                perDayList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              } else if (int.parse(day) == perDayList.last.timestamp) {
                perDayList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              } else {
                double value = 0.0;
                for (Value t in perDayList) {
                  value += t.value;
                }
                value /= perDayList.length;
                lineDayValData.add(new Value(perDayList.last.timestamp, value));
                perDayList.clear();
                perDayList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              }

              if (valList.length == counter) {
                double value = 0.0;
                for (Value t in perDayList) {
                  value += t.value;
                }
                value /= perDayList.length;
                lineDayValData.add(new Value(perDayList.last.timestamp, value));
                perDayList.clear();
              }
            }

            //Nacht
            else {
              if (perNightList.isEmpty) {
                perNightList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              } else if (int.parse(day) == perNightList.last.timestamp) {
                perNightList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              } else {
                double value = 0.0;
                for (Value t in perNightList) {
                  value += t.value;
                }
                value /= perNightList.length;
                lineNightValData
                    .add(new Value(perNightList.last.timestamp, value));
                perNightList.clear();
                perNightList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              }

              if (valList.length == counter) {
                double value = 0.0;
                for (Value t in perNightList) {
                  value += t.value;
                }
                value /= perNightList.length;
                lineNightValData
                    .add(new Value(perNightList.last.timestamp, value));
                perNightList.clear();
              }
            }
          }
        }
        if (lineDayValData.isNotEmpty) {
          _seriesWeekData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff990000)),
              id: 'Dag',
              data: lineDayValData,
              domainFn: (Value value, _) => value.timestamp - 1,
              measureFn: (Value value, _) => value.value,
            ),
          );
        }

        if (lineNightValData.isNotEmpty) {
          _seriesWeekData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff3366cc)),
              id: 'Nacht',
              data: lineNightValData,
              domainFn: (Value value, _) => value.timestamp - 1,
              measureFn: (Value value, _) => value.value,
            ),
          );
        }
      });
    });
  }

  _getMonthValList() {
    MeasurementApi.getMeasurementsFromSensor(id, token).then((result) {
      setState(() {
        _seriesMonthData = [];
        valList = result;
        valList.sort((a, b) {
          return a.timestamp.compareTo(b.timestamp);
        });
        List<Value> perDayList = [];
        List<Value> perNightList = [];

        var lineDayValData = <Value>[];
        var lineNightValData = <Value>[];
        int counter = 0;
        for (Measurement m in valList) {
          counter++;
          var today = DateTime.now();
          var measurementDate = DateTime.parse(m.timestamp);
          Duration difference = today.difference(measurementDate);
          String day = m.timestamp.split('T')[0].split('-')[2];
          int hour = int.parse(m.timestamp.split('T')[1].split(':')[0]);

          if (difference.inDays <= 31 && measurementDate.isBefore(today)) {
            if (hour >= 6 && hour <= 18) {
              if (perDayList.isEmpty) {
                perDayList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              } else if (int.parse(day) == perDayList.last.timestamp) {
                perDayList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              } else {
                double value = 0.0;
                for (Value t in perDayList) {
                  value += t.value;
                }
                value /= perDayList.length;
                lineDayValData.add(new Value(perDayList.last.timestamp, value));
                perDayList.clear();
                perDayList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              }

              if (valList.length == counter) {
                double value = 0.0;
                for (Value t in perDayList) {
                  value += t.value;
                }
                value /= perDayList.length;
                lineDayValData.add(new Value(perDayList.last.timestamp, value));
                perDayList.clear();
              }
            }

            //Nacht
            else {
              if (perNightList.isEmpty) {
                perNightList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              } else if (int.parse(day) == perNightList.last.timestamp) {
                perNightList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              } else {
                double value = 0.0;
                for (Value t in perNightList) {
                  value += t.value;
                }
                value /= perNightList.length;
                lineNightValData
                    .add(new Value(perNightList.last.timestamp, value));
                perNightList.clear();
                perNightList
                    .add(new Value(int.parse(day), double.parse(m.value)));
              }

              if (valList.length == counter) {
                double value = 0.0;
                for (Value t in perNightList) {
                  value += t.value;
                }
                value /= perNightList.length;
                lineNightValData
                    .add(new Value(perNightList.last.timestamp, value));
                perNightList.clear();
              }
            }
          }
        }

        if (lineDayValData.isNotEmpty) {
          _seriesMonthData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff990011)),
              id: 'Dag',
              data: lineDayValData,
              domainFn: (Value value, _) => value.timestamp - 1,
              measureFn: (Value value, _) => value.value,
            ),
          );
        }
        if (lineNightValData.isNotEmpty) {
          _seriesMonthData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff3366cc)),
              id: 'Nacht',
              data: lineNightValData,
              domainFn: (Value value, _) => value.timestamp - 1,
              measureFn: (Value value, _) => value.value,
            ),
          );
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
    if (valList == null ||
        sensor == null ||
        _seriesDayData == null ||
        _seriesWeekData == null ||
        _seriesMonthData == null) {
      // show a ProgressIndicator as long as there's no map info
      return Center(child: CircularProgressIndicator());
    } else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            bottom: TabBar(
              indicatorColor: Color(0xFF000000),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.dailymotion),
                ),
                Tab(icon: Icon(FontAwesomeIcons.wordpress)),
                Tab(icon: Icon(FontAwesomeIcons.maxcdn)),
              ],
            ),
            title: Text(sensor.name),
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
                            'Nog geen metingen vandaag',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        if (_seriesDayData.isNotEmpty)
                          Text(
                            'Metingen van vandaag',
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
                                new charts.ChartTitle(
                                    sensor.sensorType.name +
                                        ' in ' +
                                        sensor.sensorType.unit,
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
                                          desiredTickCount: 12)),
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
                            'Nog geen metingen deze week',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        if (_seriesWeekData.isNotEmpty)
                          Text(
                            'Metingen van deze week',
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
                                new charts.ChartTitle(
                                    sensor.sensorType.name +
                                        ' in ' +
                                        sensor.sensorType.unit,
                                    behaviorPosition:
                                        charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                                new charts.SeriesLegend()
                              ],
                              domainAxis: new charts.NumericAxisSpec(
                                viewport: new charts.NumericExtents(0, 6),
                                tickProviderSpec:
                                    new charts.BasicNumericTickProviderSpec(
                                  zeroBound: true,
                                  desiredTickCount: 14,
                                ),
                                tickFormatterSpec: customWeekFormatter,
                              ),
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
                        if (_seriesMonthData.isEmpty)
                          Text(
                            'Nog geen metingen deze maand',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        if (_seriesMonthData.isNotEmpty)
                          Text(
                            'Metingen van deze maand',
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
                                new charts.ChartTitle(
                                    sensor.sensorType.name +
                                        ' in ' +
                                        sensor.sensorType.unit,
                                    behaviorPosition:
                                        charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                                new charts.SeriesLegend()
                              ],
                              domainAxis: new charts.NumericAxisSpec(
                                viewport: new charts.NumericExtents(0, 30),
                                tickProviderSpec:
                                    new charts.BasicNumericTickProviderSpec(
                                        zeroBound: true, desiredTickCount: 16),
                                tickFormatterSpec: customMonthFormatter,
                              ),
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
