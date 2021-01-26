class UserType {
  int id;
  String userTypeName;

  UserType({this.id, this.userTypeName});

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(id: json['userTypeID'], userTypeName: json['userTypeName']);
  }
}
