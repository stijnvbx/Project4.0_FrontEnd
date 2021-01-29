import 'package:project4_front_end/models/box.dart';
import 'package:project4_front_end/models/location.dart';

class BoxUser {
  int id;
  int boxID;
  int userID;
  String startDate;
  String endDate;
  Box box;
  List<Location> locations;

  BoxUser(
      {this.id,
      this.boxID,
      this.userID,
      this.startDate,
      this.endDate,
      this.box,
      this.locations});

  factory BoxUser.fromJson(Map<String, dynamic> json) {
    return BoxUser(
        id: json['boxUserID'],
        boxID: json['boxID'],
        userID: json['userID'],
        startDate: json['startDate'],
        endDate: json['endDate']);
  }

  factory BoxUser.fromJsonWithBoxAndLocations(Map<String, dynamic> json) {

    var list = json['locations'] as List;
    List<Location> locationsList = list.map((i) => Location.fromJson(i)).toList();

    return BoxUser(
        id: json['boxUserID'],
        boxID: json['boxID'],
        userID: json['userID'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        box: Box.fromJson(json['box']),
        locations: locationsList);
  }

  Map<String, dynamic> toJson() => {
        'boxUserID': id,
        'boxID': boxID,
        'userID': userID,
        'startDate': startDate,
        'endDate': endDate
      };
}
