import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project4_front_end/models/user_type.dart';

class UserTypeApi {

  static String url = "https://40.115.25.181:5001/api/UserType";

  // GET -> All userTypes
  static Future<List<UserType>> getuserTypes() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((userType) => new UserType.fromJson(userType)).toList();
    } else {
      throw Exception('Failed to load userTypes!');
    }
  }

  // GET -> userType
  static Future<UserType> getUserType(int id) async {
    final response = await http.get(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return UserType.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load userType!');
    }
  }

  // POST -> Create userType
  static Future<UserType> createUserType(UserType userType) async {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userType),
    );
    if (response.statusCode == 201) {
      return UserType.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create userType!');
    }
  }

  // PUT -> update userType
  static Future<UserType> updateUserType(int id, UserType userType) async {
    final http.Response response = await http.put(
      url + '/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userType),
    );
    if (response.statusCode == 200) {
      return UserType.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update userType!');
    }
  }

  // DELETE -> userType
  static Future deleteUserType(int id) async {
    final http.Response response =
        await http.delete(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete userType!');
    }
  }
}