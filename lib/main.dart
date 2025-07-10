import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/database_service.dart';
import 'screens/login_screen.dart';
import 'screens/create_password_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final masterPassword = await DatabaseService.getMasterPassword();
  runApp(MyApp(masterPasswordExists: masterPassword != null));
}

class MyApp extends StatelessWidget {
  final bool masterPasswordExists;
  const MyApp({super.key, required this.masterPasswordExists});

  @override
  Widget build(BuildContext context) {
    return _AppLifecycleHandler(
      child: MaterialApp(
        title: 'Moress',
        debugShowCheckedModeBanner: false,
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
        home: masterPasswordExists ? const LoginScreen() : const CreatePasswordScreen(),
        routes: {
          '/home': (_) => const HomeScreen(),
          '/login': (_) => const LoginScreen(),
          '/create-password': (_) => const CreatePasswordScreen(),
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
