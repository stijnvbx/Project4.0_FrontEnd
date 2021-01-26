import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:project4_front_end/apis/user_api.dart';
import 'package:project4_front_end/models/user.dart';
import 'package:project4_front_end/pages/home.dart';
import 'package:project4_front_end/widgets/bottomNavbar.dart';
import 'package:project4_front_end/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  User user = User();
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
    setSelectedIndex(0);
  }

  setSelectedIndex(int selectedIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', selectedIndex);
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
                    if (value.length < 2) {
                      return "Enter at least 2 characters";
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            elevation: 2.0,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(
        onTabSelected: _selectedTab,
        items: [],
      ),
    );
  }

  setUserID(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userID', user.id);
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getInt('userID');
      print("test: " + userID.toString());
    });
  }

  void _signin() {
    user.email = emailController.text;
    user.password = passwordController.text;
    if (user.email != "" && user.password != "") {
      UserApi.getUserLogin(user.email, user.password).then((user) {
        if (user.isEmpty) {
          Flushbar(
            title: "Sign up failed",
            message: "Your email or password was incorrect.",
            duration: Duration(seconds: 2),
          ).show(context);
        } else {
          setUserID(user[0]);
          getData();
          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.routeName, (_) => false);
          Flushbar(
            title: "Logged in",
            message: "You are logged in.",
            duration: Duration(seconds: 2),
          ).show(context);
        }
      });
    } else {
      Flushbar(
        title: "Log in failed",
        message: "Please fill in every field.",
        duration: Duration(seconds: 2),
      ).show(context);
    }
  }
}
