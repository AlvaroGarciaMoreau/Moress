import 'dart:math' as math;
import 'package:flutter/material.dart';

class PasswordAnalyzer {
  static const List<String> commonPasswords = [
    '123456', 'password', '123456789', '12345678', '12345', '1234567',
    'qwerty', 'abc123', 'football', 'monkey', 'letmein', '696969',
    'shadow', 'master', '666666', 'qwertyuiop', '123321', 'mustang',
    '1234567890', 'michael', '654321', 'pussy', 'superman', '1qaz2wsx',
    '7777777', 'fuckyou', '121212', '000000', 'qazwsx', '123qwe',
    'killer', 'trustno1', 'jordan', 'jennifer', 'zxcvbnm', 'asdfgh',
    'hunter', 'buster', 'soccer', 'harley', 'batman', 'andrew',
    'tigger', 'sunshine', 'iloveyou', 'fuckme', '2000', 'charlie',
    'robert', 'thomas', 'hockey', 'ranger', 'daniel', 'starwars',
    'klaster', '112233', 'george', 'asshole', 'computer', 'michelle',
    'jessica', 'pepper', '1111', 'zxcvbn', '555555', '11111111',
    '131313', 'freedom', '777777', 'pass', 'fuck', 'maggie',
    '159753', 'aaaaaa', 'ginger', 'princess', 'joshua', 'cheese',
    'amanda', 'summer', 'love', 'ashley', '6969', 'nicole',
    'chelsea', 'biteme', 'matthew', 'access', 'yankees', '987654321',
    'dallas', 'austin', 'thunder', 'taylor', 'matrix'
  ];

  static PasswordStrength analyzePassword(String password) {
    if (password.isEmpty) {
      return PasswordStrength(
        score: 0,
        level: SecurityLevel.veryWeak,
        feedback: ['La contraseña no puede estar vacía'],
        estimatedCrackTime: 'Inmediato',
      );
    }

    int score = 0;
    List<String> feedback = [];
    List<String> strengths = [];

    // Verificar longitud
    if (password.length < 6) {
      feedback.add('Usa al menos 6 caracteres');
    } else if (password.length < 8) {
      feedback.add('Considera usar al menos 8 caracteres');
      score += 1;
    } else if (password.length >= 12) {
      strengths.add('Longitud excelente');
      score += 3;
    } else {
      strengths.add('Buena longitud');
      score += 2;
    }

    // Verificar tipos de caracteres
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int characterTypes = 0;
    if (hasLower) characterTypes++;
    if (hasUpper) characterTypes++;
    if (hasDigits) characterTypes++;
    if (hasSpecial) characterTypes++;

    switch (characterTypes) {
      case 1:
        feedback.add('Usa una mezcla de letras, números y símbolos');
        break;
      case 2:
        feedback.add('Añade números y símbolos especiales');
        score += 1;
        break;
      case 3:
        strengths.add('Buena variedad de caracteres');
        score += 2;
        break;
      case 4:
        strengths.add('Excelente variedad de caracteres');
        score += 3;
        break;
    }

    // Verificar patrones comunes
    if (_isCommonPassword(password.toLowerCase())) {
      feedback.add('Esta es una contraseña muy común');
      score = math.max(0, score - 2);
    }

    if (_hasSequentialChars(password)) {
      feedback.add('Evita secuencias obvias como "123" o "abc"');
      score = math.max(0, score - 1);
    }

    if (_hasRepeatedChars(password)) {
      feedback.add('Evita repetir caracteres consecutivos');
      score = math.max(0, score - 1);
    }

    // Verificar patrones de teclado
    if (_hasKeyboardPattern(password)) {
      feedback.add('Evita patrones del teclado como "qwerty"');
      score = math.max(0, score - 1);
    }

    // Determinar nivel de seguridad
    SecurityLevel level;
    if (score <= 1) {
      level = SecurityLevel.veryWeak;
    } else if (score <= 3) {
      level = SecurityLevel.weak;
    } else if (score <= 5) {
      level = SecurityLevel.fair;
    } else if (score <= 7) {
      level = SecurityLevel.good;
    } else {
      level = SecurityLevel.strong;
    }

    // Estimar tiempo de crack
    String estimatedCrackTime = _estimateCrackTime(password, characterTypes);

    // Combinar feedback
    List<String> allFeedback = [...feedback];
    if (strengths.isNotEmpty && feedback.isEmpty) {
      allFeedback.add('¡Excelente contraseña!');
    }

    return PasswordStrength(
      score: score,
      level: level,
      feedback: allFeedback,
      estimatedCrackTime: estimatedCrackTime,
    );
  }

  static bool _isCommonPassword(String password) {
    return commonPasswords.contains(password);
  }

  static bool _hasSequentialChars(String password) {
    for (int i = 0; i < password.length - 2; i++) {
      String substr = password.substring(i, i + 3);
      if (_isSequential(substr)) return true;
    }
    return false;
  }

  static bool _isSequential(String chars) {
    for (int i = 0; i < chars.length - 1; i++) {
      if (chars.codeUnitAt(i + 1) != chars.codeUnitAt(i) + 1) {
        return false;
      }
    }
    return true;
  }

  static bool _hasRepeatedChars(String password) {
    for (int i = 0; i < password.length - 2; i++) {
      if (password[i] == password[i + 1] && password[i + 1] == password[i + 2]) {
        return true;
      }
    }
    return false;
  }

  static bool _hasKeyboardPattern(String password) {
    List<String> patterns = [
      'qwerty', 'asdfgh', 'zxcvbn', 'qwertyuiop', 'asdfghjkl',
      'zxcvbnm', '1234567890', 'qazwsx', 'wsxedc'
    ];
    
    String lower = password.toLowerCase();
    for (String pattern in patterns) {
      if (lower.contains(pattern) || lower.contains(pattern.split('').reversed.join())) {
        return true;
      }
    }
    return false;
  }

  static String _estimateCrackTime(String password, int characterTypes) {
    int charset = 0;
    if (characterTypes >= 1) charset += 26; // lowercase
    if (characterTypes >= 2) charset += 26; // uppercase
    if (characterTypes >= 3) charset += 10; // digits
    if (characterTypes >= 4) charset += 32; // special chars

    double combinations = math.pow(charset.toDouble(), password.length.toDouble()).toDouble();
    
    // Asumiendo 1 billón de intentos por segundo
    double seconds = combinations / 1000000000000;
    
    if (seconds < 1) return 'Inmediato';
    if (seconds < 60) return '${seconds.round()} segundos';
    if (seconds < 3600) return '${(seconds / 60).round()} minutos';
    if (seconds < 86400) return '${(seconds / 3600).round()} horas';
    if (seconds < 2592000) return '${(seconds / 86400).round()} días';
    if (seconds < 31536000) return '${(seconds / 2592000).round()} meses';
    
    double years = seconds / 31536000;
    if (years < 1000) return '${years.round()} años';
    if (years < 1000000) return '${(years / 1000).round()}K años';
    if (years < 1000000000) return '${(years / 1000000).round()}M años';
    
    return 'Siglos';
  }
}

enum SecurityLevel {
  veryWeak,
  weak,
  fair,
  good,
  strong,
}

class PasswordStrength {
  final int score;
  final SecurityLevel level;
  final List<String> feedback;
  final String estimatedCrackTime;

  PasswordStrength({
    required this.score,
    required this.level,
    required this.feedback,
    required this.estimatedCrackTime,
  });

  String get levelName {
    switch (level) {
      case SecurityLevel.veryWeak:
        return 'Muy débil';
      case SecurityLevel.weak:
        return 'Débil';
      case SecurityLevel.fair:
        return 'Regular';
      case SecurityLevel.good:
        return 'Buena';
      case SecurityLevel.strong:
        return 'Fuerte';
    }
  }

  Color get levelColor {
    switch (level) {
      case SecurityLevel.veryWeak:
        return const Color(0xFFD32F2F);
      case SecurityLevel.weak:
        return const Color(0xFFFF9800);
      case SecurityLevel.fair:
        return const Color(0xFFFFC107);
      case SecurityLevel.good:
        return const Color(0xFF4CAF50);
      case SecurityLevel.strong:
        return const Color(0xFF2E7D32);
    }
  }

  double get progressValue {
    return (score / 8).clamp(0.0, 1.0);
  }
}
