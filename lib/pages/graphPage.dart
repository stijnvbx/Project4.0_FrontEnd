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

  Sensor sensor;

  List<Measurement> valList;
  List<charts.Series<Temp, int>> _seriesDayData = [];
  List<charts.Series<Temp, int>> _seriesWeekData = [];
  List<charts.Series<Temp, int>> _seriesMonthData = [];

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
    _getDayTempList();
    _getWeekTempList();
    _getMonthTempList();
  }

  _getSensorWithType() {
    SensorApi.getSensor(id, token).then((result) {
      setState(() {
        sensor = result;
        print(sensor.sensorType.name);
      });
    });
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

              lineDayData.add(new Temp(perHourList.last.timestamp, value));
              perHourList.clear();
              perHourList.add(new Temp(int.parse(hour), double.parse(m.value)));
            }

            if (valList.length == counter) {
              double value = 0.0;
              for (Temp t in perHourList) {
                value += t.value;
              }
              value /= perHourList.length;
              lineDayData.add(new Temp(perHourList.last.timestamp, value));
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
          String day = m.timestamp.split('T')[0].split('-')[2];
          int hour = int.parse(m.timestamp.split('T')[1].split(':')[0]);

          if (measurementDate.weekOfYear == today.weekOfYear) {
            if (hour >= 6 && hour <= 18) {
              //print("Hour of day: " + hour.toString() + " day: " + day);
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
                lineDayTempData.add(new Temp(perDayList.last.timestamp, value));
                perDayList.clear();
                perDayList.add(new Temp(int.parse(day), double.parse(m.value)));
              }

              if (valList.length == counter) {
                double value = 0.0;
                for (Temp t in perDayList) {
                  value += t.value;
                }
                value /= perDayList.length;
                lineDayTempData.add(new Temp(perDayList.last.timestamp, value));
                perDayList.clear();
              }
            }

            //Nacht
            else {
              //print("Hour of night: " + hour.toString() + " day " + day);
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
                lineNightTempData
                    .add(new Temp(perNightList.last.timestamp, value));
                perNightList.clear();
                perNightList
                    .add(new Temp(int.parse(day), double.parse(m.value)));
              }

              if (valList.length == counter) {
                double value = 0.0;
                for (Temp t in perNightList) {
                  value += t.value;
                }
                value /= perNightList.length;
                lineNightTempData
                    .add(new Temp(perNightList.last.timestamp, value));
                perNightList.clear();
              }
            }
          }
        }
        if (lineDayTempData.isNotEmpty) {
          _seriesWeekData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff990000)),
              id: 'Dag',
              data: lineDayTempData,
              domainFn: (Temp temperature, _) => temperature.timestamp - 1,
              measureFn: (Temp temperature, _) => temperature.value,
            ),
          );
        }

        if (lineNightTempData.isNotEmpty) {
          _seriesWeekData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff3366cc)),
              id: 'Nacht',
              data: lineNightTempData,
              domainFn: (Temp temperature, _) => temperature.timestamp - 1,
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
              //print("Hour of day: " + hour.toString() + " day: " + day);
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
                lineDayTempData.add(new Temp(perDayList.last.timestamp, value));
                perDayList.clear();
                perDayList.add(new Temp(int.parse(day), double.parse(m.value)));
              }

              if (valList.length == counter) {
                double value = 0.0;
                for (Temp t in perDayList) {
                  value += t.value;
                }
                value /= perDayList.length;
                lineDayTempData.add(new Temp(perDayList.last.timestamp, value));
                perDayList.clear();
              }
            }

            //Nacht
            else {
              //print("Hour of night: " + hour.toString() + " day " + day);
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
                lineNightTempData
                    .add(new Temp(perNightList.last.timestamp, value));
                perNightList.clear();
                perNightList
                    .add(new Temp(int.parse(day), double.parse(m.value)));
              }

              if (valList.length == counter) {
                double value = 0.0;
                for (Temp t in perNightList) {
                  value += t.value;
                }
                value /= perNightList.length;
                lineNightTempData
                    .add(new Temp(perNightList.last.timestamp, value));
                perNightList.clear();
              }
            }
          }
        }

        if (lineDayTempData.isNotEmpty) {
          _seriesMonthData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff990011)),
              id: 'Dag',
              data: lineDayTempData,
              domainFn: (Temp temperature, _) => temperature.timestamp - 1,
              measureFn: (Temp temperature, _) => temperature.value,
            ),
          );
        }
        if (lineNightTempData.isNotEmpty) {
          _seriesMonthData.add(
            charts.Series(
              colorFn: (__, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xff3366cc)),
              id: 'Nacht',
              data: lineNightTempData,
              domainFn: (Temp temperature, _) => temperature.timestamp - 1,
              measureFn: (Temp temperature, _) => temperature.value,
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
        _seriesDayData.isEmpty ||
        _seriesWeekData.isEmpty ||
        _seriesMonthData.isEmpty) {
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
                        Text(
                          'Metingen van vandaag',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
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
                                        zeroBound: true, desiredTickCount: 12)),
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
                        Text(
                          'Metingen van deze week',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
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
                        Text(
                          'Metingen van deze maand',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
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
