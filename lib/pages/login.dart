import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:project4_front_end/models/user.dart';
import 'package:project4_front_end/pages/register.dart';
import 'package:project4_front_end/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';

class Login extends StatefulWidget {
  static const routeName = '/';
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  String _passwordError;
  User user;
  int userID;

  @override
  void initState() {
    super.initState();
    //getData(null);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: Navbar(tabName: 'Login'),
      //drawer: MainDrawer(),
      body: new SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
              child: new Text(
                'Welcome',
                style: TextStyle(
                    fontFamily: 'Poppins', color: Colors.grey, fontSize: 60),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: new Text(
                'Log in',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                  fontSize: 40,
                ),
              ),
            ),
            // E-mail
            new ListTile(
              title: new TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: new InputDecoration(
                  hintText: "E-mail",
                  labelText: "E-mail",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            ),
            // Password
            Form(
              key: _formKey,
              child: new ListTile(
                title: new TextFormField(
                  validator: (String value) {
                    if (value.length < 4) {
                      return "Enter at least 4 characters";
                    } else {
                      return null;
                    }
                  },
                  controller: passwordController,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    labelText: "Password",
                    errorText: _passwordError,
                  ),
                  obscureText: true,
                ),
                contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              ),
            ),

            const SizedBox(height: 40),
            RaisedButton(
              onPressed: () {
                // Authenticate the user
                _signin();
              },
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text('Log in',
                  style: TextStyle(fontSize: 22, color: Colors.white)),
            ),

            FlatButton(
              onPressed: () {
                // Go to sign up page
                _signup();
              },
              child: Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
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

  setUserID(User username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userID', username.id);
  }

  getData(int i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getInt('userID');
      print("test: " + userID.toString());
      if (userID != null) {
        //Navigator.pushNamed(context, MyMaps.routeName, arguments: userID);
        if (i != null) {
          Flushbar(
            title: "Logged in",
            message: "You are logged in.",
            duration: Duration(seconds: 3),
          ).show(context);
        }
      }
    });
  }

  void _signin() {
    if (emailController.text != "" && passwordController.text != "") {
      /*UserApi.fetchUserLogin(user.username, user.password).then((username) {
        if (username.isEmpty) {
          Flushbar(
            title: "Sign up failed",
            message: "Your username or password was incorrect.",
            duration: Duration(seconds: 3),
          ).show(context);
        } else {
          setUserID(username[0]);
          getData(1);
        }
      });*/
    } else {
      Flushbar(
        title: "Log in failed",
        message: "Please fill in every field.",
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }

  void _signup() {
    Navigator.of(context).pushNamed(Register.routeName);
  }
}
