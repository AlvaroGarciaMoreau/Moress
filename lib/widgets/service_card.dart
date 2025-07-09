import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/service.dart';

class ServiceCard extends StatefulWidget {
  final Service service;
  final VoidCallback onDelete;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onDelete,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                      color: const Color(0xFF667eea).withOpacity(0.1),
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
                        Text(
                          widget.service.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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