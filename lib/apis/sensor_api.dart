import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project4_front_end/models/sensor.dart';

class SensorApi {
  static String url = "https://project40backend2.azurewebsites.net/api/Sensor";

  // GET -> All sensors
  static Future<List<Sensor>> getSensors() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sensor) => new Sensor.fromJson(sensor)).toList();
    } else {
      throw Exception('Failed to load sensors!');
    }
  }

  // GET -> sensor
  static Future<Sensor> getSensor(int id, String token) async {
    final response = await http.get(
      url + '/' + id.toString(),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return Sensor.fromJsonWithSensorType(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load sensor!');
    }
  }

  // POST -> Create sensor
  static Future<Sensor> createSensor(Sensor sensor) async {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sensor),
    );
    if (response.statusCode == 201) {
      return Sensor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create sensor!');
    }
  }

  // PUT -> update sensor
  static Future<Sensor> updateSensor(int id, Sensor sensor) async {
    final http.Response response = await http.put(
      url + '/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sensor),
    );
  }

  // DELETE -> sensor
  static Future deleteSensor(int id) async {
    final http.Response response = await http.delete(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete sensor!');
    }
  }
}
