import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/service.dart';
import 'encryption_service.dart';

class DatabaseService {
  static Database? _database;
  static const String _appPassword = "Moress123!"; // Contraseña maestra de la app

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'moress.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE services(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        password TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Verificar contraseña maestra
  static bool verifyMasterPassword(String password) {
    return password == _appPassword;
  }

  // Obtener todos los servicios
  static Future<List<Service>> getServices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('services', orderBy: 'name ASC');
    
    return List.generate(maps.length, (i) {
      final service = Service.fromMap(maps[i]);
      return Service(
        id: service.id,
        name: service.name,
        password: EncryptionService.decrypt(service.password),
        createdAt: service.createdAt,
      );
    });
  }

  // Buscar servicios por nombre
  static Future<List<Service>> searchServices(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'services',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
    );
    
    return List.generate(maps.length, (i) {
      final service = Service.fromMap(maps[i]);
      return Service(
        id: service.id,
        name: service.name,
        password: EncryptionService.decrypt(service.password),
        createdAt: service.createdAt,
      );
    });
  }

  // Insertar nuevo servicio
  static Future<int> insertService(Service service) async {
    final db = await database;
    final encryptedService = Service(
      name: service.name,
      password: EncryptionService.encrypt(service.password),
      createdAt: service.createdAt,
    );
    return await db.insert('services', encryptedService.toMap());
  }

  // Actualizar servicio
  static Future<int> updateService(Service service) async {
    final db = await database;
    final encryptedService = Service(
      id: service.id,
      name: service.name,
      password: EncryptionService.encrypt(service.password),
      createdAt: service.createdAt,
    );
    return await db.update(
      'services',
      encryptedService.toMap(),
      where: 'id = ?',
      whereArgs: [service.id],
    );
  }

  // Eliminar servicio
  static Future<int> deleteService(int id) async {
    final db = await database;
    return await db.delete(
      'services',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 