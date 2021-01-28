import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:project4_front_end/apis/measurement_api.dart';
import 'package:project4_front_end/models/measurement.dart';

class TempChart extends StatefulWidget {
  static const routeName = "/TempChart";
  @override
  _TempChartState createState() => _TempChartState();
}

class _TempChartState extends State<TempChart> {
  List<Measurement> tempList;

  void _getTemps() {
    MeasurementApi.getMeasurementsFromSensor(4).then((result) {
      setState(() {
        tempList = result;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getTemps();
  }

  @override
  Widget build(BuildContext context) {
    print(tempList[0].value);
  }
}
