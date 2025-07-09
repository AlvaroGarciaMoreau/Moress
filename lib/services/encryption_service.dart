import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static const String _masterKey = "Moress2024SecureKey"; // En producción, esto debería estar en variables de entorno
  
  static String _generateKey() {
    final key = utf8.encode(_masterKey);
    final hash = sha256.convert(key);
    return hash.toString().substring(0, 32);
  }

  static String encrypt(String text) {
    if (text.isEmpty) return text;
    
    final key = _generateKey();
    final bytes = utf8.encode(text);
    final encrypted = _xorEncrypt(bytes, key);
    return base64.encode(encrypted);
  }

  static String decrypt(String encryptedText) {
    if (encryptedText.isEmpty) return encryptedText;
    
    try {
      final key = _generateKey();
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