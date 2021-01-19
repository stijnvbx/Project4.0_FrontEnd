class User {
  int id;
  String firstName;
  String lastName;
  String password;
  String email;
  String street;
  String housenr;
  String bus;
  String postalcode;
  String city;
  int userTypeID;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.password,
      this.email,
      this.street,
      this.housenr,
      this.bus,
      this.postalcode,
      this.city,
      this.userTypeID});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      password: json['password'],
      street: json['street'],
      housenr: json['housenr'],
      bus: json['bus'],
      postalcode: json['postalcode'],
      city: json['city'],
      userTypeID: json['userTypeID']
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'street': street,
        'housenr': housenr,
        'bus': bus,
        'postalcode': postalcode,
        'city': city,
        'userTypeID': userTypeID
      };
}