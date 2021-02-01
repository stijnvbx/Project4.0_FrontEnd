class Monitoring {
  int id;
  int boxID;
  String sdCapacity;
  bool batteryStatus;
  double batteryPercentage;

  Monitoring(
      {this.id,
      this.boxID,
      this.sdCapacity,
      this.batteryStatus,
      this.batteryPercentage});

  factory Monitoring.fromJson(Map<String, dynamic> json) {
    return Monitoring(
        id: json['monitoringID'],
        boxID: json['boxID'],
        sdCapacity: json['sdCapacity'],
        batteryStatus: json['batteryStatus'],
        batteryPercentage: json['batteryPercentage']);
  }

  Map<String, dynamic> toJson() => {
        'monitoringID': id,
        'boxID': boxID,
        'sdCapacity': sdCapacity,
        'batteryStatus': batteryStatus,
        'batteryPercentage': batteryPercentage
      };
}
