import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/service.dart';
import '../services/remote_service.dart';
import '../services/user_service.dart';
import '../services/theme_service.dart';
import '../widgets/service_card.dart';
import 'add_service_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<Service> _services = [];
  List<Service> _filteredServices = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  Timer? _inactivityTimer;
  Timer? _warningTimer;
  bool _isAppInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadServicesAndCount();
    _startInactivityTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _inactivityTimer?.cancel();
    _warningTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
        // App minimizada o perdió el foco - cerrar sesión por seguridad
        _isAppInBackground = true;
        _cancelTimers();
        _logout();
        break;
      case AppLifecycleState.inactive:
        // App en transición (ej: llamada entrante, selector de apps) - cerrar sesión por seguridad
        _isAppInBackground = true;
        _cancelTimers();
        _logout();
        break;
      case AppLifecycleState.detached:
        // App siendo cerrada
        _isAppInBackground = true;
        _cancelTimers();
        _logout();
        break;
      case AppLifecycleState.resumed:
        // App regresó al primer plano
        if (_isAppInBackground && mounted) {
          // Si la app estaba en background, forzar logout al volver
          _logout();
        } else if (mounted) {
          _startInactivityTimer();
        }
        _isAppInBackground = false;
        break;
      case AppLifecycleState.hidden:
        // App oculta (solo en algunas plataformas)
        _isAppInBackground = true;
        _cancelTimers();
        _logout();
        break;
    }
  }

  void _cancelTimers() {
    _inactivityTimer?.cancel();
    _warningTimer?.cancel();
  }

  void _startInactivityTimer() {
    // Cancelar timers existentes
    _inactivityTimer?.cancel();
    _warningTimer?.cancel();
    
    // Timer de advertencia (25 segundos)
    _warningTimer = Timer(const Duration(seconds: 25), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La app se cerrará por inactividad en 5 segundos...'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
      }
    });
    
    // Timer de cierre (30 segundos)
    _inactivityTimer = Timer(const Duration(seconds: 30), () {
      if (mounted) {
        SystemNavigator.pop();
      }
    });
  }

  void _onUserInteraction([_]) {
    // Reiniciar el timer cada vez que hay interacción
    _startInactivityTimer();
  }

  Future<void> _loadServicesAndCount() async {
    setState(() { _isLoading = true; });
    try {
      final uuid = await UserService.getOrCreateUuid();
      final services = await RemoteService.listarServicios(uuid);
      setState(() {
        _services = services;
        _filteredServices = services;
      
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar servicios: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  void _searchServices(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredServices = _services;
      } else {
        _filteredServices = _services
            .where((service) =>
                service.name.toLowerCase().contains(query.toLowerCase()) ||
                service.user.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _addService() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddServiceScreen()),
    );
    if (result == true) {
      _loadServicesAndCount();
    }
  }

  Future<void> _deleteService(Service service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar servicio'),
        content: Text('¿Estás seguro de que quieres eliminar "${service.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && service.id != null) {
      try {
        final uuid = await UserService.getOrCreateUuid();
        final success = await RemoteService.borrarServicio(service.id!, uuid);
        if (success) {
          _loadServicesAndCount();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Servicio eliminado correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          throw Exception('No se pudo eliminar el servicio');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar servicio: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _logout() {
    // Cancelar timers antes de salir
    _cancelTimers();
    
    // Navegar al login y remover todas las rutas anteriores
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => _ChangePasswordDialog(onChanged: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña cambiada correctamente'), backgroundColor: Colors.green),
        );
      }),
    );
  }

  void _showSettingsDialog() {
    final themeService = context.read<ThemeService>();
    ThemeMode selected = themeService.themeMode;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Sistema'),
                  value: ThemeMode.system,
                  groupValue: selected,
                  onChanged: (v) => setState(() => selected = v!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Claro'),
                  value: ThemeMode.light,
                  groupValue: selected,
                  onChanged: (v) => setState(() => selected = v!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Oscuro'),
                  value: ThemeMode.dark,
                  groupValue: selected,
                  onChanged: (v) => setState(() => selected = v!),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await themeService.setThemeMode(selected);
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onUserInteraction,
      onPointerMove: _onUserInteraction,
      onPointerUp: _onUserInteraction,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Moress',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF667eea),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Configuración',
              onPressed: _showSettingsDialog,
            ),
            IconButton(
              icon: const Icon(Icons.vpn_key),
              tooltip: 'Cambiar contraseña maestra',
              onPressed: () {
                _onUserInteraction();
                _showChangePasswordDialog();
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _onUserInteraction();
                _logout();
              },
              tooltip: 'Cerrar sesión',
            ),
          ],
        ),
        body: Column(
          children: [
            // Buscador
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _onUserInteraction();
                  _searchServices(value);
                },
                onTap: _onUserInteraction,
                decoration: InputDecoration(
                  hintText: 'Buscar servicios...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
              
              // Lista de servicios
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _filteredServices.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _searchController.text.isEmpty
                                      ? Icons.lock_outline
                                      : Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isEmpty
                                      ? 'No hay servicios guardados'
                                      : 'No se encontraron servicios',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (_searchController.text.isEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Toca el botón + para añadir tu primer servicio',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () {
                              _onUserInteraction();
                              return _loadServicesAndCount();
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _filteredServices.length,
                              itemBuilder: (context, index) {
                                final service = _filteredServices[index];
                                return ServiceCard(
                                  service: service,
                                  onDelete: () {
                                    _onUserInteraction();
                                    _deleteService(service);
                                  },
                                  onEdited: () {
                                    _onUserInteraction();
                                    _loadServicesAndCount();
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _onUserInteraction();
              _addService();
            },
            backgroundColor: const Color(0xFF667eea),
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        ),
      );
  }
}


class _ChangePasswordDialog extends StatefulWidget {
  final VoidCallback onChanged;
  const _ChangePasswordDialog({required this.onChanged});

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
  
    setState(() { _isLoading = false; });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidad no disponible en modo remoto'), backgroundColor: Colors.orange),
    );
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar Contraseña Maestra'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _currentController,
              obscureText: _obscureCurrent,
              decoration: InputDecoration(
                labelText: 'Contraseña actual',
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrent ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce la contraseña actual';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newController,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce la nueva contraseña';
                }
                if (value.length < 6) {
                  return 'Debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmController,
              obscureText: _obscureNew,
              decoration: const InputDecoration(
                labelText: 'Repite la nueva contraseña',
              ),
              validator: (value) {
                if (value != _newController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _changePassword,
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Cambiar'),
        ),
      ],
    );
  }
} 