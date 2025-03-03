import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<void> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");

  if (token != null) {
    // Decode the token
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Extract user_id
    String userId = decodedToken["id"].toString();

    print("User ID: $userId");
  } else {
    print("No token found!");
  }
}
