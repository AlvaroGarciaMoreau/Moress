class Service {
  final int? id;
  final String name;
  final String user;
  final String password;
  final String createdAt; // Ahora es String

  Service({
    this.id,
    required this.name,
    required this.user,
    required this.password,
    String? createdAt,
  }) : createdAt = createdAt ?? _nowEs();

  static String _nowEs() {
    final now = DateTime.now();
    final meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${now.day} de ${meses[now.month - 1]} de ${now.year}, '
           '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user': user,
      'password': password,
      'createdAt': createdAt,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      name: map['name'],
      user: map['user'],
      password: map['password'],
      createdAt: map['createdAt'],
    );
  }
} 