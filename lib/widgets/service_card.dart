import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/service.dart';
import '../services/remote_service.dart';
import '../services/user_service.dart';

class ServiceCard extends StatefulWidget {
  final Service service;
  final VoidCallback onDelete;
  final VoidCallback? onEdited;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onDelete,
    this.onEdited,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _showPassword = false;
  bool _isCopied = false;

  void _togglePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _copyPassword() {
    Clipboard.setData(ClipboardData(text: widget.service.password));
    setState(() {
      _isCopied = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contraseña copiada al portapapeles'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );

    // Resetear el estado después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  void _showEditDialog() async {
    final result = await showDialog<Service>(
      context: context,
      builder: (context) => _EditServiceDialog(service: widget.service),
    );
    if (result != null) {
      if (widget.onEdited != null) widget.onEdited!();
    }
  }

  Color _getCardColor() {
    // Intenta parsear la fecha
    try {
      if (widget.service.createdAt != null) {
        final partes = widget.service.createdAt!.split(' de ');
        if (partes.length >= 3) {
          final dia = int.parse(partes[0]);
          final mesStr = partes[1].trim();
          final anio = int.parse(partes[2].split(',')[0].trim());
          final meses = [
            'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
            'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
          ];
          final mes = meses.indexOf(mesStr) + 1;
          final fecha = DateTime(anio, mes, dia);
          final ahora = DateTime.now();
          final diferencia = ahora.difference(fecha);
          if (diferencia.inDays > 180) {
            // Más de 6 meses
            return const Color(0xFFFFE5E5); // Rojo pastel suave
          }
        }
      }
    } catch (_) {}
    return const Color(0xFFE5FFF1); // Verde pastel suave
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: _getCardColor(),
      child: InkWell(
        onTap: _togglePassword,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre y botones
              Row(
                children: [
                  // Icono del servicio
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea).withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.business,
                      color: Color(0xFF667eea),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Nombre del servicio
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.service.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Indicador de recordatorio
                            // Indicador de recordatorio eliminado (modo remoto)
                          ],
                        ),
                        Text(
                          widget.service.user,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Creado: ${widget.service.createdAt}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Botones de acción
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón editar
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: _showEditDialog,
                        tooltip: 'Editar servicio',
                      ),
                      // Botón copiar
                      if (_showPassword)
                        IconButton(
                          icon: Icon(
                            _isCopied ? Icons.check : Icons.copy,
                            color: _isCopied ? Colors.green : Colors.grey[600],
                            size: 20,
                          ),
                          onPressed: _copyPassword,
                          tooltip: 'Copiar contraseña',
                        ),
                      
                      // Botón eliminar
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: widget.onDelete,
                        tooltip: 'Eliminar servicio',
                      ),
                    ],
                  ),
                ],
              ),
              
              // Contraseña (oculta/mostrada)
              if (_showPassword) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock,
                        size: 16,
                        color: Color(0xFF667eea),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.service.password,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.visibility_off,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onPressed: _togglePassword,
                        tooltip: 'Ocultar contraseña',
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Toca para mostrar la contraseña',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 

class _EditServiceDialog extends StatefulWidget {
  final Service service;
  const _EditServiceDialog({required this.service});

  @override
  State<_EditServiceDialog> createState() => _EditServiceDialogState();
}

class _EditServiceDialogState extends State<_EditServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
  super.initState();
  _userController = TextEditingController(text: widget.service.user);
  _passwordController = TextEditingController(text: widget.service.password);
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });
    final newPassword = _passwordController.text;
    final updatedService = Service(
      id: widget.service.id,
      name: widget.service.name,
      user: _userController.text.trim(),
      password: newPassword,
      createdAt: widget.service.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
    try {
      final uuid = await UserService.getOrCreateUuid();
      final success = await RemoteService.guardarServicio(updatedService, uuid);
      setState(() { _isLoading = false; });
      if (mounted && success) {
        Navigator.of(context).pop(updatedService);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar cambios'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() { _isLoading = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Servicio'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor introduce el usuario';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor introduce la contraseña';
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
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Guardar'),
        ),
      ],
    );
  }
} 