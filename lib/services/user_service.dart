import 'package:shared_preferences/shared_preferences.dart';
class UserService {
  static const String _emailKey = 'user_email';

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }
}
