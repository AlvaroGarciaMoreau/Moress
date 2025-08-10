class Service {
  final int? id;
  final String name;      // servicio
  final String user;      // usuario
  final String password;  // contrasena
  final String? createdAt;
  final String? updatedAt;

  Service({
    this.id,
    required this.name,
    required this.user,
    required this.password,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'servicio': name,
      'usuario': user,
      'contrasena': password,
      'fecha_creacion': createdAt,
      'fecha_actualizacion': updatedAt,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      name: map['servicio'] ?? '',
      user: map['usuario'] ?? '',
      password: map['contrasena'] ?? '',
      createdAt: map['fecha_creacion'],
      updatedAt: map['fecha_actualizacion'],
    );
  }
}