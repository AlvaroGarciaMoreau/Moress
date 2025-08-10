import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service.dart';
import 'encryption_service.dart';

class RemoteService {
  static const String baseUrl = 'https://www.moreausoft.com/Moress/'; // Cambia por tu dominio real

  static Future<List<Service>> listarServicios(String email) async {
    final response = await http.get(Uri.parse('${baseUrl}listar_servicios.php?email=$email'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Service> services = [];
      for (final e in data) {
        final decrypted = await EncryptionService.decrypt(e['contrasena'] ?? '');
        services.add(Service(
          id: e['id'],
          name: e['servicio'],
          user: e['usuario'],
          password: decrypted,
          createdAt: e['fecha_creacion'],
          updatedAt: e['fecha_actualizacion'],
        ));
      }
      return services;
    } else {
      throw Exception('Error al listar servicios');
    }
  }

  static Future<bool> guardarServicio(Service service, String email) async {
    // Crear payload y encriptar contraseña antes de enviar
    final encrypted = await EncryptionService.encrypt(service.password);
    final payload = service.toMap()
      ..['email'] = email
      ..['contrasena'] = encrypted;

    final response = await http.post(
      Uri.parse('${baseUrl}guardar_servicio.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );
    final data = json.decode(response.body);
    return data['success'] == true;
  }

  static Future<bool> borrarServicio(int id, String email) async {
    final response = await http.post(
      Uri.parse('${baseUrl}borrar_servicio.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'email': email,
      }),
    );
    final data = json.decode(response.body);
    return data['success'] == true;
  }
}
