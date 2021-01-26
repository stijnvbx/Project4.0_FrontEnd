class Box {
  int id;
  String macAddress;
  String name;
  String comment;
  bool active;

  Box({this.id, this.macAddress, this.name, this.comment, this.active});

  factory Box.fromJson(Map<String, dynamic> json) {
    return Box(
        id: json['boxID'],
        macAddress: json['macAddress'],
        name: json['name'],
        comment: json['comment'],
        active: json['active']);
  }
}
