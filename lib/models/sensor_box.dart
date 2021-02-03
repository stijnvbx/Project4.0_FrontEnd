import 'package:project4_front_end/models/sensor.dart';

class SensorBox {
  int boxID;
  int sensorID;
  Sensor sensor;

  SensorBox({this.boxID, this.sensorID, this.sensor});

  factory SensorBox.fromJson(Map<String, dynamic> json) {
    return SensorBox(boxID: json['boxID'], sensorID: json['sensorID']);
  }

  factory SensorBox.fromJsonBoxSensorsMeasurements(Map<String, dynamic> json) {
    return SensorBox(
        boxID: json['boxID'],
        sensorID: json['sensorID'],
        sensor: Sensor.fromJson(json['sensor']));
  }

  Map<String, dynamic> toJson() => {
        'boxID': boxID,
        'sensorID': sensorID,
      };
}
