import 'package:project4_front_end/models/box.dart';
import 'package:project4_front_end/models/location.dart';

class BoxUser {
  int id;
  int boxID;
  int userID;
  String startDate;
  String endDate;

  BoxUser({this.id, this.boxID, this.userID, this.startDate, this.endDate});

  factory BoxUser.fromJson(Map<String, dynamic> json) {
    return BoxUser(
        id: json['boxUserID'],
        boxID: json['boxID'],
        userID: json['userID'],
        startDate: json['startDate'],
        endDate: json['endDate']);
  }

  Map<String, dynamic> toJson() => {
        'boxUserID': id,
        'boxID': boxID,
        'userID': userID,
        'startDate': startDate,
        'endDate': endDate
      };
}
