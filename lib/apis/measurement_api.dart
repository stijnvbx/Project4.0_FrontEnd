import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project4_front_end/models/measurement.dart';

class MeasurementApi {

  static String url = "https://40.115.25.181:5001/api/Measurement";

  // GET -> All measurements
  static Future<List<Measurement>> getMeasurements() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((measurement) => new Measurement.fromJson(measurement)).toList();
    } else {
      throw Exception('Failed to load measurements!');
    }
  }

  // GET -> measurement
  static Future<Measurement> getMeasurement(int id) async {
    final response = await http.get(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return Measurement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load measurement!');
    }
  }

  // POST -> Create measurement
  static Future<Measurement> createMeasurement(Measurement measurement) async {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(measurement),
    );
    if (response.statusCode == 201) {
      return Measurement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create measurement!');
    }
  }

  // PUT -> update measurement
  static Future<Measurement> updateMeasurement(int id, Measurement measurement) async {
    final http.Response response = await http.put(
      url + '/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(measurement),
    );
    print("statusCode: " + response.statusCode.toString());
  }

  // DELETE -> measurement
  static Future deleteMeasurement(int id) async {
    final http.Response response =
        await http.delete(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete measurement!');
    }
  }
}