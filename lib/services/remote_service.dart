import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service.dart';

class RemoteService {
  static const String baseUrl = 'https://www.moreausoft.com/Moress/'; // Cambia por tu dominio real

  static Future<List<Service>> listarServicios(String uuid) async {
    final response = await http.get(Uri.parse('${baseUrl}listar_servicios.php?uuid=$uuid'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Service(
        id: e['id'],
        name: e['servicio'],
        user: e['usuario'],
        password: e['contrasena'],
      )).toList();
    } else {
      throw Exception('Error al listar servicios');
    }
  }

  static Future<bool> guardarServicio(Service service, String uuid) async {
    final response = await http.post(
      Uri.parse('${baseUrl}guardar_servicio.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': service.id,
        'uuid': uuid,
        'servicio': service.name,
        'usuario': service.user,
        'contrasena': service.password,
      }),
    );
    final data = json.decode(response.body);
    return data['success'] == true;
  }

  static Future<bool> borrarServicio(int id, String uuid) async {
    final response = await http.post(
      Uri.parse('${baseUrl}borrar_servicio.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'uuid': uuid,
      }),
    );
    final data = json.decode(response.body);
    return data['success'] == true;
  }
}
