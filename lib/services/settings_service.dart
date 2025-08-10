import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _warningTimeoutKey = 'warning_timeout';
  static const String _logoutTimeoutKey = 'logout_timeout';
  static const String _autoLogoutEnabledKey = 'auto_logout_enabled';
  static const String _biometricEnabledKey = 'biometric_enabled';
  
  // Valores por defecto
  static const int defaultWarningTimeout = 25; // segundos
  static const int defaultLogoutTimeout = 30; // segundos
  static const bool defaultAutoLogoutEnabled = true;
  static const bool defaultBiometricEnabled = true;
  
  // Getter methods
  static Future<int> getWarningTimeout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_warningTimeoutKey) ?? defaultWarningTimeout;
  }
  
  static Future<int> getLogoutTimeout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_logoutTimeoutKey) ?? defaultLogoutTimeout;
  }
  
  static Future<bool> getAutoLogoutEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoLogoutEnabledKey) ?? defaultAutoLogoutEnabled;
  }
  
  static Future<bool> getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? defaultBiometricEnabled;
  }
  
  // Setter methods
  static Future<void> setWarningTimeout(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_warningTimeoutKey, seconds);
  }
  
  static Future<void> setLogoutTimeout(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_logoutTimeoutKey, seconds);
  }
  
  static Future<void> setAutoLogoutEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoLogoutEnabledKey, enabled);
  }
  
  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }
  
  // Métodos de utilidad
  static List<int> getTimeoutOptions() {
    return [10, 15, 20, 25, 30, 45, 60, 120, 300]; // segundos
  }
  
  static String formatTimeout(int seconds) {
    if (seconds < 60) {
      return '$seconds segundos';
    } else if (seconds == 60) {
      return '1 minuto';
    } else if (seconds < 3600) {
      final minutes = (seconds / 60).round();
      return '$minutes minutos';
    } else {
      final hours = (seconds / 3600).round();
      return '$hours horas';
    }
  }
}
