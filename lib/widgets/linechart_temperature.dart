import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Linechart extends StatefulWidget {
  final Widget child;

  Linechart({Key key, this.child}) : super(key: key);
  _Linechartstate createState() => _Linechartstate();
}

class Temperature {
  int timestamp;
  int temperature;

  Temperature(this.timestamp, this.temperature);
}

class _Linechartstate extends State<Linechart> {
  List<charts.Series<Temperature, int>> _seriesLineData;

  _generateData() {
    var temps = [1, 2, 3]; //Hier komen de temperaturen uit de database
    var lineAirTempData = <Temperature>[];
    var lineGroundTempData = <Temperature>[];
    for (int i = 0; i < temps.length; i++) {
      lineAirTempData.add(new Temperature(i, temps[i]));
      //lineGroundTempData.add(new Temp(i, temps[i] - 3));
    }

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Lucht',
        data: lineAirTempData,
        domainFn: (Temperature temperature, _) => temperature.timestamp,
        measureFn: (Temperature temperature, _) => temperature.temperature,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Grond',
        data: lineGroundTempData,
        domainFn: (Temperature temperature, _) => temperature.timestamp,
        measureFn: (Temperature temperature, _) => temperature.temperature,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesLineData = List<charts.Series<Temperature, int>>();
    _generateData();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff1976d2),
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
              ],
            ),
            title: Text('Flutter Charts'),
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
