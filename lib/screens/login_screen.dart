import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database_service.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      setState(() {
        _canCheckBiometrics = canCheck && isDeviceSupported;
      });
    } catch (e) {
      setState(() {
        _canCheckBiometrics = false;
      });
      // Error checking biometrics, logged but not shown to user
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      // Verificar que la biometría esté disponible
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      
      if (!isAvailable || !isDeviceSupported) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('La autenticación biométrica no está disponible en este dispositivo'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Obtener los métodos biométricos disponibles
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No hay métodos biométricos configurados en el dispositivo'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Autentícate con tu huella dactilar para acceder a Moress',
        options: const AuthenticationOptions(
          biometricOnly: true, 
          stickyAuth: true,
        ),
      );
      
      if (didAuthenticate && mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on PlatformException catch (e) {
      if (mounted) {
        String errorMessage;
        switch (e.code) {
          case 'NotAvailable':
            errorMessage = 'La autenticación biométrica no está disponible';
            break;
          case 'NotEnrolled':
            errorMessage = 'No hay huellas dactilares registradas en el dispositivo';
            break;
          case 'LockedOut':
            errorMessage = 'Demasiados intentos fallidos. Intenta de nuevo más tarde';
            break;
          case 'PermanentlyLockedOut':
            errorMessage = 'La autenticación biométrica está permanentemente bloqueada';
            break;
          case 'BiometricOnlyNotSupported':
            errorMessage = 'Este dispositivo no soporta autenticación solo con biometría';
            break;
          default:
            errorMessage = 'Error de autenticación biométrica: ${e.message ?? 'Error desconocido'}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { _isLoading = true; });
    final isValid = await DatabaseService.verifyMasterPassword(_passwordController.text);
    setState(() { _isLoading = false; });
    if (isValid) {
      // Navegar a la pantalla principal
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Contraseña incorrecta'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de imagen
          Positioned.fill(
            child: Image.asset(
              'assets/fondo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay de degradado
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xAA667eea),
                    Color(0xAA764ba2),
                  ],
                ),
              ),
            ),
          ),
          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo o título de la app
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.2 * 255).toInt()),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Moress',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gestor de Contraseñas',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      if (_canCheckBiometrics) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.fingerprint),
                            label: const Text('Acceder con huella'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF667eea),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _authenticateWithBiometrics,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('O accede con tu contraseña', style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 16),
                      ],
                      
                      // Campo de contraseña
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.1 * 255).toInt()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Introduce la contraseña maestra',
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor introduce la contraseña';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _login(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Botón de login
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF667eea),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF667eea),
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Acceder',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                     ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 