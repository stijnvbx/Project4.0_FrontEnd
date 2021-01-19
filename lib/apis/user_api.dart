import 'package:http/http.dart' as http;

class UserApi {

  static String userUrl = "";

  static Future getUsers() async {
    return await http.get(userUrl);
  }
}