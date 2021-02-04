import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project4_front_end/models/box_user.dart';

class BoxUserApi {

  static String url = "https://project40backend2.azurewebsites.net/api/BoxUser";

  // GET -> All boxUsers
  static Future<List<BoxUser>> getBoxUsers(String token) async {
    final response = await http.get(url,
    headers: {HttpHeaders.authorizationHeader: "Bearer $token"},);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((boxUser) => new BoxUser.fromJsonWithBoxAndLocations(boxUser)).toList();
    } else {
      throw Exception('Failed to load boxUsers!');
    }
  }

  // GET -> All boxUsers
  static Future<List<BoxUser>> getBoxUserWithUserId(int id, String token) async {
    final response = await http.get(url + '/userId/$id',
    headers: {HttpHeaders.authorizationHeader: "Bearer $token"},);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((boxUser) => new BoxUser.fromJsonWithBoxAndLocations(boxUser)).toList();
    } else {
      throw Exception('Failed to load boxUsers!');
    }
  }

  // GET -> boxUser
  static Future<BoxUser> getBoxUser(int id) async {
    final response = await http.get(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return BoxUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load boxUser!');
    }
  }

  // POST -> Create boxUser
  static Future<BoxUser> createBoxUser(BoxUser boxUser) async {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(boxUser),
    );
    if (response.statusCode == 201) {
      return BoxUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create boxUser!');
    }
  }

  // PUT -> update boxUser
  static Future<BoxUser> updateBoxUser(int id, BoxUser boxUser) async {
    final http.Response response = await http.put(
      url + '/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(boxUser),
    );
    print("statusCode: " + response.statusCode.toString());
  }

  // DELETE -> boxUser
  static Future deleteBoxUser(int id) async {
    final http.Response response =
        await http.delete(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete boxUser!');
    }
  }
}