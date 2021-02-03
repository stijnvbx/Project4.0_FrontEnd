import 'package:project4_front_end/models/sensor_type.dart';

class Sensor {
  int id;
  int sensorTypeID;
  String name;
  SensorType sensorType;

  Sensor({this.id, this.sensorTypeID, this.name, this.sensorType});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
        id: json['sensorID'],
        sensorTypeID: json['sensorTypeID'],
        name: json['name']);
  }

  factory Sensor.fromJsonWithSensorType(Map<String, dynamic> json) {
    return Sensor(
        id: json['sensorID'],
        sensorTypeID: json['sensorTypeID'],
        name: json['name'],
        sensorType: SensorType.fromJson(json['sensorType']));
  }

  Map<String, dynamic> toJson() =>
      {'sensorID': id, 'sensorTypeID': sensorTypeID, 'name': name};
}
