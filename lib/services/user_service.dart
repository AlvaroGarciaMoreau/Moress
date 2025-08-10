import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserService {
  static const String _uuidKey = 'user_uuid';

  static Future<String> getOrCreateUuid() async {
    final prefs = await SharedPreferences.getInstance();
    String? uuid = prefs.getString(_uuidKey);
    if (uuid == null) {
      uuid = const Uuid().v4();
      await prefs.setString(_uuidKey, uuid);
    }
    return uuid;
  }
}
