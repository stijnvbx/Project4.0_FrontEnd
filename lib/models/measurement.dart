class Measurement {
  int id;
  int boxID;
  int sensorID;
  String value;
  String timestamp;

  Measurement({this.id, this.boxID, this.sensorID, this.value, this.timestamp});

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
        id: json['measurementID'],
        boxID: json['boxID'],
        sensorID: json['sensorID'],
        value: json['value'],
        timestamp: json['timeStamp']);
  }

  Map<String, dynamic> toJson() => {
        'measurementID': id,
        'boxID': boxID,
        'sensorID': sensorID,
        'value': value,
        'timeStamp': timestamp
      };
}
