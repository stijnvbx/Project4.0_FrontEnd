class User {
  int id;
  String firstName;
  String lastName;
  String password;
  String email;
  String address;
  String postalCode;
  String city;
  int userTypeID;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.password,
      this.email,
      this.address,
      this.postalCode,
      this.city,
      this.userTypeID});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['userID'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        password: json['password'],
        email: json['email'],
        address: json['address'],
        postalCode: json['postalCode'],
        city: json['city'],
        userTypeID: json['userTypeID']);
  }

  Map<String, dynamic> toJson() => {
        'userID': id,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'email': email,
        'address': address,
        'postalCode': postalCode,
        'city': city,
        'userTypeID': userTypeID
      };
}
