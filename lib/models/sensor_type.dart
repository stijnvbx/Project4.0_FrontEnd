class SensorType {
  int id;
  String name;
  String unit;

  SensorType({this.id, this.name, this.unit});

  factory SensorType.fromJson(Map<String, dynamic> json) {
    return SensorType(
        id: json['sensorTypeID'], name: json['name'], unit: json['unit']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'unit': unit,
      };
}
