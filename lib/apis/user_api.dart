import 'dart:convert';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:project4_front_end/models/user.dart';

class UserApi {
  static String url = "https://project40backend2.azurewebsites.net/api/User";

  // GET -> All users
  static Future<List<User>> getUsers() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => new User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users!');
    }
  }

  // GET -> user login
  // static Future<List<User>> getUserLogin(String email, String password) async {
  //   final response =
  //       await http.get(url + '/login?email=' + email + '&password=' + password);
  //   if (response.statusCode == 200) {
  //     List jsonResponse = json.decode(response.body);
  //     return jsonResponse.map((user) => new User.fromJson(user)).toList();
  //   } else {
  //     throw Exception('Failed to load user!');
  //   }
  // }

  // GET -> user email
  static Future<List<User>> getUserEmail(String email, String token) async {
    final response = await http.get(url + '/email?email=' + email,
    headers: {HttpHeaders.authorizationHeader: "Bearer $token"},);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => new User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load user!');
    }
  }

  // GET -> User
  static Future<User> getUser(int id, String token) async {
    final response = await http.get(url + '/' + id.toString(),
    headers: {HttpHeaders.authorizationHeader: "Bearer $token"},);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user!');
    }
  }

  // POST -> Authenticate user
  static Future<User> userAuthenticate(User user, context) async {
    final http.Response response = await http.post(
      url + '/authenticate',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    if (response.statusCode == 200) {
      return User.fromJsonWithUserType(jsonDecode(response.body));
    } else {
      Flushbar(
            title: "Aanmelden mislukt",
            message: "Je e-mail of wachtwoord is fout.",
            duration: Duration(seconds: 2),
          ).show(context);
      throw Exception('Failed to login!');
    }
  }

  // POST -> Create user
  static Future<User> createUser(User user) async {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user!');
    }
  }

  // REST API call: PUT /users/1
  static Future<User> updateUser(int id, User user, String token) async {
    final http.Response response = await http.put(
      url + '/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(user),
    );
    // if (response.statusCode == 204) {
    //   return User.fromJson(jsonDecode(response.body));
    // } else {
    //   throw Exception('Failed to update user!');
    // }
  }

  // DELETE -> user
  static Future deleteUser(int id) async {
    final http.Response response = await http.delete(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete user!');
    }
  }
}
