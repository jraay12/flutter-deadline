import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");

  if (token != null) {
    try {
      // Decode the token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Extract and return user_id
      return decodedToken["id"].toString();
    } catch (error) {
      print("Error decoding token: $error");
      return null;
    }
  } else {
    print("No token found!");
    return null;
  }
}
