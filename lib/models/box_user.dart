class BoxUser {
  int id;
  int boxID;
  int userID;
  DateTime startDate;
  DateTime endDate;

  BoxUser({this.id, this.boxID, this.userID, this.startDate, this.endDate});

  factory BoxUser.fromJson(Map<String, dynamic> json) {
    return BoxUser(
        id: json['boxUserID'],
        boxID: json['boxID'],
        userID: json['userID'],
        startDate: json['startDate'],
        endDate: json['endDate']);
  }
}
