import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project4_front_end/models/box.dart';

class BoxApi {

  static String url = "https://project40backend2.azurewebsites.net/api/Box";

  // GET -> All boxes
  static Future<List<Box>> getBoxes() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((box) => new Box.fromJson(box)).toList();
    } else {
      throw Exception('Failed to load boxes!');
    }
  }

  // GET -> All boxes
  static Future<Box> getBoxesSensorMeasurements(int id, String token) async {
    final response = await http.get(url + '/Sensor/Measurements/$id',
    headers: {HttpHeaders.authorizationHeader: "Bearer $token"},);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Box.fromJsonBoxSensors(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load boxes!');
    }
  }

  // GET -> box
  static Future<Box> getBox(int id) async {
    final response = await http.get(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return Box.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load box!');
    }
  }

  // POST -> Create box
  static Future<Box> createBox(Box box) async {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(box),
    );
    if (response.statusCode == 201) {
      return Box.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create box!');
    }
  }

  // PUT -> update user
  static Future<Box> updateBox(int id, Box box) async {
    final http.Response response = await http.put(
      url + '/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(box),
    );
    print("statusCode: " + response.statusCode.toString());
  }

  // DELETE -> user
  static Future deleteBox(int id) async {
    final http.Response response =
        await http.delete(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete box!');
    }
  }
}