import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project4_front_end/models/monitoring.dart';

class MonitoringApi {

  static String url = "https://40.115.25.181:5001/api/Monitoring";

  // GET -> All monitorings
  static Future<List<Monitoring>> getMonitorings() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((monitoring) => new Monitoring.fromJson(monitoring)).toList();
    } else {
      throw Exception('Failed to load monitorings!');
    }
  }

  // GET -> monitoring
  static Future<Monitoring> getMonitoring(int id) async {
    final response = await http.get(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return Monitoring.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load monitoring!');
    }
  }

  // POST -> Create monitoring
  static Future<Monitoring> createMonitoring(Monitoring monitoring) async {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(monitoring),
    );
    if (response.statusCode == 201) {
      return Monitoring.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create monitoring!');
    }
  }

  // PUT -> update monitoring
  static Future<Monitoring> updateMonitoring(int id, Monitoring monitoring) async {
    final http.Response response = await http.put(
      url + '/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(monitoring),
    );
    print("statusCode: " + response.statusCode.toString());
  }

  // DELETE -> monitoring
  static Future deleteMonitoring(int id) async {
    final http.Response response =
        await http.delete(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete monitoring!');
    }
  }
}