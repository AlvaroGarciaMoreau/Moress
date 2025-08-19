---
description: Repository Information Overview
alwaysApply: true
---

# Moress Information

## Summary
Moress is a secure password manager application developed in Flutter. It allows users to securely store and manage passwords for various services and applications with features like biometric authentication, auto-locking, and encrypted backups.

## Structure
- **lib/**: Core application code (screens, services, models, widgets)
- **android/**: Android platform-specific code
- **ios/**: iOS platform-specific code
- **web/**: Web platform configuration
- **windows/**: Windows platform-specific code
- **linux/**: Linux platform-specific code
- **macos/**: macOS platform-specific code
- **assets/**: Application assets (images, icons)
- **test/**: Test files

## Language & Runtime
**Language**: Dart
**Version**: SDK ^3.8.0
**Framework**: Flutter
**Package Manager**: pub (Flutter/Dart package manager)

## Dependencies
**Main Dependencies**:
- `sqflite: ^2.3.0` - SQLite database for local storage
- `crypto: ^3.0.3` - Encryption and hashing
- `shared_preferences: ^2.2.2` - Local preferences storage
- `local_auth: ^2.1.7` - Biometric authentication
- `provider: ^6.1.1` - State management
- `file_picker: ^8.0.7` - File selection for backup/restore
- `path_provider: ^2.1.2` - Access to system directories
- `otp: ^3.1.4` - TOTP code generation for 2FA
- `qr_flutter: ^4.1.0` - QR code generation

**Development Dependencies**:
- `flutter_test` - Testing framework
- `flutter_lints: ^5.0.0` - Linting rules

## Build & Installation
```bash
flutter pub get
flutter run
```

## Application Structure
**Entry Point**: `lib/main.dart`

**Key Components**:
- **Models**: `lib/models/service.dart` - Data model for password entries
- **Screens**:
  - `lib/screens/login_screen.dart` - Authentication screen
  - `lib/screens/home_screen.dart` - Main password list with auto-lock
  - `lib/screens/add_service_screen.dart` - Add/edit password entries
  - `lib/screens/create_password_screen.dart` - Initial setup
- **Services**:
  - `lib/services/encryption_service.dart` - Password encryption
  - `lib/services/password_analyzer.dart` - Password strength analysis
  - `lib/services/theme_service.dart` - Theme management
  - `lib/services/user_service.dart` - User authentication
  - `lib/services/settings_service.dart` - App settings
  - `lib/services/responsive_service.dart` - Responsive design
- **Widgets**:
  - `lib/widgets/service_card.dart` - Password entry display

## Security Features
- Master password authentication
- Biometric authentication (fingerprint, Face ID)
- XOR encryption with SHA-256 key derivation
- Auto-lock after 30 seconds of inactivity
- Automatic logout when app is minimized or loses focus
- Encrypted local backups

## Platform Support
- **Android**: Minimum API level 23 (Android 6.0)
- **iOS**: Minimum iOS 10.0
- **Web**: Progressive Web App support
- **Desktop**: Windows, macOS, Linux support

## Testing
**Framework**: Flutter Test
**Test Location**: `test/` directory
**Run Command**:
```bash
flutter test
```