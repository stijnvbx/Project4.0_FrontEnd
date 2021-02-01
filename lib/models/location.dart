class Location {
  int id;
  int boxUserID;
  double latitude;
  double longitude;
  String startDate;
  String endDate;

  Location(
      {this.id,
      this.boxUserID,
      this.latitude,
      this.longitude,
      this.startDate,
      this.endDate});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['locationID'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        boxUserID: json['boxUserID'],
        startDate: json['startDate'],
        endDate: json['endDate']);
  }

  Map<String, dynamic> toJson() => {
        'locationID': id,
        'latitude': latitude,
        'longitude': longitude,
        'boxUserID': boxUserID,
        'startDate': startDate,
        'endDate': endDate
      };
}
