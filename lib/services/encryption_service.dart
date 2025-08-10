import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptionService {
  static const String _prefsKey = 'master_password';
  static String? _cachedKey;

  // Deriva una clave de 32 bytes (como string) del master password almacenado
  static Future<String> _generateKey() async {
    if (_cachedKey != null) return _cachedKey!;
    final prefs = await SharedPreferences.getInstance();
    final master = prefs.getString(_prefsKey) ?? '';
    final hash = sha256.convert(utf8.encode(master));
    _cachedKey = hash.toString().substring(0, 32);
    return _cachedKey!;
  }

  static Future<void> invalidateCache() async {
    _cachedKey = null;
  }

  static Future<String> encrypt(String text) async {
    if (text.isEmpty) return text;
    final key = await _generateKey();
    final bytes = utf8.encode(text);
    final encrypted = _xorEncrypt(bytes, key);
    return base64.encode(encrypted);
  }

  static Future<String> decrypt(String encryptedText) async {
    if (encryptedText.isEmpty) return encryptedText;
    try {
      final key = await _generateKey();
      final bytes = base64.decode(encryptedText);
      final decrypted = _xorEncrypt(bytes, key);
      return utf8.decode(decrypted);
    } catch (e) {
      return encryptedText; // Si falla la desencriptación, devolver el texto original
    }
  }

  static List<int> _xorEncrypt(List<int> data, String key) {
    final keyBytes = utf8.encode(key);
    final result = <int>[];
    
    for (int i = 0; i < data.length; i++) {
      result.add(data[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return result;
  }
} 