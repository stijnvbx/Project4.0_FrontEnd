import 'package:flutter/services.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
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
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  String _passwordError;

  User user;
  int userID;
  String token;

  int _selectedIndex;

  List<String> addressSplit;

  String _hash = 'Unknown';

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
      appBar: Navbar(tabName: 'Profiel'),
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
      addressSplit = user.address.split(" ");
      firstnameController.text = user.firstName;
      lastnameController.text = user.lastName;
      emailController.text = user.email;
      passwordController1.text;
      passwordController2.text;
      addressController.text = addressSplit[0];
      if (addressSplit.length == 2) {
        housenrController.text = addressSplit[1];
      } else {
        housenrController.text = "";
      }
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
                  SizedBox(height: 30),
                  // Firstname
                  TextFormField(
                    controller: firstnameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: new InputDecoration(
                      hintText: "Voornaam*",
                      labelText: "Voornaam*",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  // Lastname
                  TextFormField(
                    controller: lastnameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: new InputDecoration(
                      hintText: "Achternaam*",
                      labelText: "Achternaam*",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  // E-mail
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: new InputDecoration(
                      hintText: "E-mail*",
                      labelText: "E-mail*",
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
                          hintText: "Straat*",
                          labelText: "Straat*",
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
                          hintText: "Nr*",
                          labelText: "Nr*",
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
                          hintText: "Stad*",
                          labelText: "Stad*",
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
                          hintText: "Postcode*",
                          labelText: "Postcode*",
                        ),
                      ),
                    ),
                  ]),

                  // Password
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (String value) {
                            if (value.length < 4) {
                              return "Enter at least 4 characters";
                            } else {
                              return null;
                            }
                          },
                          controller: passwordController1,
                          textInputAction: TextInputAction.next,
                          decoration: new InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Wachtwoord",
                            labelText: "Wachtwoord",
                            errorText: _passwordError,
                          ),
                          obscureText: true,
                        ),
                        TextFormField(
                          validator: (String value) {
                            if (value.length < 4) {
                              return "Enter at least 4 characters";
                            } else {
                              return null;
                            }
                          },
                          controller: passwordController2,
                          textInputAction: TextInputAction.next,
                          decoration: new InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Wachtwoord",
                            labelText: "Voer Wachtwoord opnieuw in",
                            errorText: _passwordError,
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ButtonBar(
              buttonPadding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('Afmelden',
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  onPressed: () {
                    _showMyDialog();
                  },
                ),
                RaisedButton(
                  child: Text('Opslaan',
                      style: TextStyle(fontSize: 22, color: Colors.white)),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
    token = prefs.getString('token');
    if (userID != null) {
      UserApi.getUser(userID, token).then((result) {
        // call the api to fetch the user data
        setState(() {
          user = result;
        });
      });
    }
  }

  void _edit() {
    user.firstName = firstnameController.text;
    user.lastName = lastnameController.text;
    user.email = emailController.text;
    user.address = addressController.text + " " + housenrController.text;
    user.postalCode = zipcodeController.text;
    user.city = cityController.text;
    if ((passwordController1.text != passwordController2.text &&
            passwordController1.text == "") ||
        (passwordController1.text != passwordController2.text &&
            passwordController2.text == "")) {
      Flushbar(
        title: "Aanpassen mislukt",
        message: "de 2 wachtwoorden komen niet overeen.",
        duration: Duration(seconds: 2),
      ).show(context);
    } else if (user.firstName != "" &&
        user.lastName != "" &&
        user.email != "" &&
        user.password != "" &&
        user.postalCode != "" &&
        user.city != "" &&
        addressController.text != "" &&
        housenrController.text != "") {
      UserApi.getUserEmail(user.email, token).then((userEmail) {
        if (userEmail.isEmpty || user.id == userEmail[0].id) {
          hash();
        } else {
          Flushbar(
            title: "Aanpassen mislukt",
            message: "Het e-mail dat je wou gebruiken is al in gebruik.",
            duration: Duration(seconds: 2),
          ).show(context);
        }
      });
    } else {
      Flushbar(
        title: "Aanpassen mislukt",
        message: "Vul elk veld in.",
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
          title: Text('Aflmeden'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bent u zeker dat u wilt afmelden?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ja'),
              onPressed: () {
                Navigator.of(context).pop();
                print("log out!");
                clearUserID();
                Navigator.pushNamedAndRemoveUntil(
                    context, Login.routeName, (_) => false);
                Flushbar(
                  title: "Afgemeld",
                  message: "Je bent nu afgemeld.",
                  duration: Duration(seconds: 2),
                ).show(context);
              },
            ),
            TextButton(
              child: Text('Nee'),
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
    prefs.remove('token');
    prefs.remove('userTypeName');
  }

  Future<void> hash() async {
    String hash;
    // Platform messages may fail, so we use a try/catch PlatformException.

    if (passwordController1.text == passwordController2.text &&
        passwordController1.text != "" &&
        passwordController2.text != "") {
      print("hallo");

      try {
        hash = await FlutterBcrypt.hashPw(
            password: passwordController1.text,
            salt: r'$2a$11$C6UzMDM.H6dfI/f/IKxGhu');
        print("hash: " + hash);
      } on PlatformException {
        hash = 'Failed to get hash.';
      }

      if (!mounted) return;

      user.password = hash;
    }

    print("firstName: " + user.firstName);
    print("lastName: " + user.lastName);
    print("email: " + user.email);
    print("password: " + user.password);
    print("address: " + user.address);
    print("postalCode: " + user.postalCode);
    print("city: " + user.city);

    UserApi.updateUser(user.id, user, token).then((result) {
      Flushbar(
        title: "Aanpassen gelukt",
        message: "Je profiel is goed aangepast.",
        duration: Duration(seconds: 2),
      ).show(context);
    });
  }
}
