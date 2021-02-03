import 'package:project4_front_end/models/measurement.dart';
import 'package:project4_front_end/models/sensor.dart';

class SensorBox {
  int boxID;
  int sensorID;
  Sensor sensor;
  List<Measurement> measurements;

  SensorBox({this.boxID, this.sensorID, this.sensor, this.measurements});

  factory SensorBox.fromJson(Map<String, dynamic> json) {
    return SensorBox(boxID: json['boxID'], sensorID: json['sensorID']);
  }

  factory SensorBox.fromJsonBoxSensorsMeasurements(Map<String, dynamic> json) {
    var list = json['measurements'] as List;
    List<Measurement> measurementList =
        list.map((i) => Measurement.fromJson(i)).toList();

    return SensorBox(
        boxID: json['boxID'],
        sensorID: json['sensorID'],
        sensor: Sensor.fromJsonWithSensorType(json['sensor']),
        measurements: measurementList);
  }

  Map<String, dynamic> toJson() => {
        'boxID': boxID,
        'sensorID': sensorID,
      };
}
