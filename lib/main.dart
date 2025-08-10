import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/theme_service.dart';
import 'screens/login_screen.dart';
import 'screens/create_password_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bloquear la aplicación solo en orientación vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Verificar si ya existe una contraseña maestra
  final prefs = await SharedPreferences.getInstance();
  final hasMasterPassword = prefs.containsKey('master_password');
  
  runApp(MyApp(initialRoute: hasMasterPassword ? '/login' : '/create-password'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
              title: 'Moress',
              debugShowCheckedModeBanner: false,
              themeMode: themeService.themeMode,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: const Color(0xFF667eea),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF667eea),
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF667eea),
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Color(0xFF667eea),
                  foregroundColor: Colors.white,
                ),
              ),
              darkTheme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: const Color(0xFF667eea),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF667eea),
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
                scaffoldBackgroundColor: const Color(0xFF121212),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF1F1F1F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                cardTheme: const CardThemeData(
                  color: Color(0xFF1E1E1E),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Color(0xFF667eea),
                  foregroundColor: Colors.white,
                ),
              ),
              initialRoute: initialRoute,
              routes: {
                '/home': (_) => const HomeScreen(),
                '/login': (_) => const LoginScreen(),
                '/create-password': (_) => const CreatePasswordScreen(),
              },
            );
        },
      ),
    );
  }
}


