import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return _AppLifecycleHandler(
            child: MaterialApp(
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
              home: const LoginScreen(),
              routes: {
                '/home': (_) => HomeScreenWrapper(),
                '/login': (_) => const LoginScreen(),
                '/create-password': (_) => const CreatePasswordScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}

class _AppLifecycleHandler extends StatefulWidget {
  final Widget child;
  const _AppLifecycleHandler({required this.child});

  @override
  State<_AppLifecycleHandler> createState() => _AppLifecycleHandlerState();
}

class _AppLifecycleHandlerState extends State<_AppLifecycleHandler> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
