class Sensor {
  int id;
  int sensorTypeID;
  String name;

  Sensor({this.id, this.sensorTypeID, this.name});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
        id: json['sensorID'],
        sensorTypeID: json['sensorTypeID'],
        name: json['name']);
  }

  Map<String, dynamic> toJson() =>
      {'sensorID': id, 'sensorTypeID': sensorTypeID, 'name': name};
}
