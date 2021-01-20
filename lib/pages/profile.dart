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
  TextEditingController streetController = TextEditingController();
  TextEditingController housenrController = TextEditingController();
  TextEditingController busController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  String _passwordError;
  User user;
  int userID;

  @override
  void initState() {
    super.initState();
    //getData();
    user = new User(
      firstName: "",
      lastName: "",
      email: "",
      password: "",
      street: "",
      housenr: "",
      bus: "",
      postalcode: "",
      city: "",
      userTypeID: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: Navbar(tabName: 'Sign up'),
      //drawer: MainDrawer(),
      body: new SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: new Text(
                'Welcome',
                style: TextStyle(
                    fontFamily: 'Poppins', color: Colors.grey, fontSize: 60),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: new Text(
                'Sign up',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                  fontSize: 40,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                children: <Widget>[
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
                        controller: streetController,
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
                    SizedBox(width: 10),
                    SizedBox(
                      width: 50,
                      // Bus
                      child: TextFormField(
                        controller: busController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: new InputDecoration(
                          hintText: "Bus",
                          labelText: "Bus",
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
            SizedBox(height: 40),
            RaisedButton(
              onPressed: () {
                // Authenticate the new user & create one
                // _signup();
              },
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text('Sign up',
                  style: TextStyle(fontSize: 22, color: Colors.white)),
            ),
            FlatButton(
              onPressed: () {
                // Go to login in page
                _back();
              },
              child: Text(
                "Back",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: null,
            child: CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage("assets/logo.png"),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /*void _signup() {
    user.firstName = firstnameController.text;
    user.lastName = lastnameController.text;
    user.username = usernameController.text;
    user.email = emailController.text;
    user.password = passwordController.text;
    if (user.firstName != "" &&
        user.lastName != "" &&
        user.username != "" &&
        user.email != "" &&
        user.password != "") {
      if (user.password.length > 3) {
        UserApi.fetchUsername(user.username).then((username) {
          if (username.isEmpty) {
            UserApi.createUser(user).then((result) {
              Navigator.of(context).pushNamed('/');
              setUserID(result);
              getData();
              Flushbar(
                title: "Sign up succesful",
                message: "You have create a new account with username: " +
                    user.username +
                    ".",
                duration: Duration(seconds: 3),
              ).show(context);
            });
          } else {
            Flushbar(
              title: "Sign up failed",
              message: "The username you tried to use is already in use.",
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Sign up failed",
          message: "The password needs to be longer then 3 characters.",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    } else {
      Flushbar(
        title: "Sign up failed",
        message: "Please fill in every field.",
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }*/

  setUserID(User username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userID', username.id);
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getInt('userID');
      print("test: " + userID.toString());
    });
  }

  void _back() {
    Navigator.pushNamedAndRemoveUntil(context, Login.routeName, (_) => false);
  }
}
