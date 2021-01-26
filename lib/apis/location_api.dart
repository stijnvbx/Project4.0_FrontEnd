import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project4_front_end/models/location.dart';

class LocationApi {

  static String url = "https://40.115.25.181:5001/api/Location";

  // GET -> All locations
  static Future<List<Location>> getLocations() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((location) => new Location.fromJson(location)).toList();
    } else {
      throw Exception('Failed to load locations!');
    }
  }

  // GET -> location
  static Future<Location> getLocation(int id) async {
    final response = await http.get(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return Location.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load location!');
    }
  }

  // POST -> Create location
  static Future<Location> createLocation(Location location) async {
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(location),
    );
    if (response.statusCode == 201) {
      return Location.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create location!');
    }
  }

  // PUT -> update location
  static Future<Location> updateLocation(int id, Location location) async {
    final http.Response response = await http.put(
      url + '/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(location),
    );
    if (response.statusCode == 200) {
      return Location.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update location!');
    }
  }

  // DELETE -> location
  static Future deleteLocation(int id) async {
    final http.Response response =
        await http.delete(url + '/' + id.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete location!');
    }
  }
}