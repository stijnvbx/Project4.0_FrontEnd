import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:project4_front_end/apis/measurement_api.dart';
import 'package:project4_front_end/models/measurement.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  int sensorID = 0;

  static List<Measurement> tempList;

  LineChart(this.seriesList, {this.animate});

  static _getTempList() {
    MeasurementApi.getMeasurementsFromSensor(4).then((result) {
      tempList = result;
      return tempList;
    });
  }

  /// Creates a [LineChart] with sample data and no transition.
  factory LineChart.withSampleData() {
    return new LineChart(
      _getTemps(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList, animate: animate);
  }

  static List<charts.Series<Measurement, int>> _getTemps() {
    return [
      new charts.Series<Measurement, int>(
        id: 'Temperatures',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Measurement measurement, _) =>
            int.parse(measurement.timestamp.split(':')[1]),
        measureFn: (Measurement measurement, _) => int.parse(measurement.value),
        data: _getTempList(),
      )
    ];
  }
}
