import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project4_front_end/models/sensor_type.dart';

class SensorTypeApi {

  static String url = "https://40.115.25.181:5001/api/SensorType";

  // GET -> All sensorTypes
  static Future<List<SensorType>> getSensorTypes() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sensorType) => new SensorType.fromJson(sensorType)).toList();
    } else {
      throw Exception('Failed to load sensorTypes!');
    }
  }

  // GET -> sensorType
  static Future<SensorType> getSensorType(int id) async {
    final response = await http.get(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return SensorType.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load sensorType!');
    }
  }

  // POST -> Create sensorType
  static Future<SensorType> createSensorType(SensorType sensorType) async {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sensorType),
    );
    if (response.statusCode == 201) {
      return SensorType.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create sensorType!');
    }
  }

  // PUT -> update sensorType
  static Future<SensorType> updateSensorType(int id, SensorType sensorType) async {
    final http.Response response = await http.put(
      url + '/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sensorType),
    );
    print("statusCode: " + response.statusCode.toString());
  }

  // DELETE -> sensorType
  static Future deleteSensorType(int id) async {
    final http.Response response =
        await http.delete(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete sensorType!');
    }
  }
}