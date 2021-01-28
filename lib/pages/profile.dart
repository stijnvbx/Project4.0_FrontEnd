import 'package:project4_front_end/apis/user_api.dart';
import 'package:project4_front_end/models/user.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';
import 'package:project4_front_end/widgets/navbar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project4_front_end/pages/login.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController housenrController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  String _passwordError;

  User user;
  int userID;

  int _selectedIndex;

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: Navbar(tabName: 'Profile'),
      body: _profile(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: null,
            child: CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage("assets/logo.png"),
            ),
            elevation: 2.0,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(
        onTabSelected: _selectedTab,
        items: [
          CustomAppBarItem(icon: Icons.home),
          CustomAppBarItem(icon: Icons.graphic_eq),
          CustomAppBarItem(icon: Icons.add_alert),
          CustomAppBarItem(icon: Icons.person),
        ],
      ),
    );
  }

  _profile() {
    if (user == null) {
      // show a ProgressIndicator as long as there's no map info
      return Center(child: CircularProgressIndicator());
    } else {
      var addressSplit = user.address.split(" ");
      firstnameController.text = user.firstName;
      lastnameController.text = user.lastName;
      emailController.text = user.email;
      passwordController.text = user.password;
      addressController.text = addressSplit[0];
      housenrController.text = addressSplit[1];
      zipcodeController.text = user.postalCode;
      cityController.text = user.city;

      return new SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 80),
                  // Firstname
                  TextFormField(
                    controller: firstnameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: new InputDecoration(
                      hintText: "Firstname",
                      labelText: "Firstname",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  // Lastname
                  TextFormField(
                    controller: lastnameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: new InputDecoration(
                      hintText: "Lastname",
                      labelText: "Lastname",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  // E-mail
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: new InputDecoration(
                      hintText: "E-mail",
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  Row(children: <Widget>[
                    Flexible(
                      // Street
                      child: TextFormField(
                        controller: addressController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: new InputDecoration(
                          hintText: "Street",
                          labelText: "Street",
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 40,
                      // housenr
                      child: TextFormField(
                        controller: housenrController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: new InputDecoration(
                          hintText: "Nr",
                          labelText: "Nr",
                        ),
                      ),
                    ),
                  ]),
                  Row(children: <Widget>[
                    Flexible(
                      // City
                      child: TextFormField(
                        controller: cityController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: new InputDecoration(
                          hintText: "City",
                          labelText: "City",
                          prefixIcon: Icon(Icons.location_city),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 70,
                      // Zipcode
                      child: TextFormField(
                        controller: zipcodeController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: new InputDecoration(
                          hintText: "Zipcode",
                          labelText: "Zipcode",
                        ),
                      ),
                    ),
                  ]),

                  // Password
                  Form(
                    key: _formKey,
                    child: new TextFormField(
                      validator: (String value) {
                        if (value.length < 4) {
                          return "Enter at least 4 characters";
                        } else {
                          return null;
                        }
                      },
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Password",
                        labelText: "Password",
                        errorText: _passwordError,
                      ),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ButtonBar(
              buttonPadding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('Log out',
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    _showMyDialog();
                  },
                ),
                RaisedButton(
                  child: Text('Save',
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    _edit();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getInt('userID');
    if (userID != null) {
      UserApi.getUser(userID).then((result) {
        // call the api to fetch the user data
        setState(() {
          user = result;
          print("test: " + user.toString());
        });
      });
    }
  }

  void _edit() {
    user.firstName = firstnameController.text;
    user.lastName = lastnameController.text;
    user.email = emailController.text;
    user.password = passwordController.text;
    user.address = addressController.text + " " + housenrController.text;
    user.postalCode = zipcodeController.text;
    user.city = cityController.text;
    print(user.firstName);
    print(user.lastName);
    print(user.email);
    print(user.password);
    print(user.address);
    print(user.postalCode);
    print(user.city);
    if (user.firstName != "" &&
        user.lastName != "" &&
        user.email != "" &&
        user.password != "" &&
        user.postalCode != "" &&
        user.city != "" &&
        addressController.text != "" &&
        housenrController.text != "") {
      UserApi.getUserEmail(user.email).then((userEmail) {
        if (userEmail.isEmpty || user.id == userEmail[0].id) {
          UserApi.updateUser(user.id, user).then((result) {
            Flushbar(
              title: "Edit succesful",
              message:
                  "You have edited the user with email: " + user.email + ".",
              duration: Duration(seconds: 2),
            ).show(context);
          });
        } else {
          Flushbar(
            title: "Edit failed",
            message: "The email you tried to use is already in use.",
            duration: Duration(seconds: 2),
          ).show(context);
        }
      });
    } else {
      Flushbar(
        title: "Edit failed",
        message: "Please fill in every field.",
        duration: Duration(seconds: 2),
      ).show(context);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // close when tappen out of dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                print("log out!");
                clearUserID();
                Navigator.pushNamedAndRemoveUntil(
                    context, Login.routeName, (_) => false);
                Flushbar(
                  title: "Logged out",
                  message: "You are succesfully logged out.",
                  duration: Duration(seconds: 2),
                ).show(context);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                print("Don't log out!");
              },
            ),
          ],
        );
      },
    );
  }

  clearUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userID');
  }
}
