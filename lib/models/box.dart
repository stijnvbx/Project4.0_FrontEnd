import 'package:project4_front_end/models/sensor_box.dart';

class Box {
  int id;
  String macAddress;
  String name;
  String comment;
  bool active;
  List<SensorBox> sensorBoxes;

  Box({this.id, this.macAddress, this.name, this.comment, this.active, this.sensorBoxes});

  factory Box.fromJson(Map<String, dynamic> json) {
    return Box(
        id: json['boxID'],
        macAddress: json['macAddress'],
        name: json['name'],
        comment: json['comment'],
        active: json['active']);
  }

  factory Box.fromJsonBoxSensors(Map<String, dynamic> json) {
    var list = json['sensorBoxes'] as List;
    List<SensorBox> sensorBoxList =
        list.map((i) => SensorBox.fromJsonBoxSensorsMeasurements(i)).toList();

    return Box(
        id: json['boxID'],
        macAddress: json['macAddress'],
        name: json['name'],
        comment: json['comment'],
        active: json['active'],
        sensorBoxes: sensorBoxList);
  }

  Map<String, dynamic> toJson() => {
        'boxID': id,
        'macAddress': macAddress,
        'name': name,
        'comment': comment,
        'active': active
      };
}
