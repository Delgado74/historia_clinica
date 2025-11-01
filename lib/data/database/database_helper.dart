import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../core/app_constants.dart';
import '../models/paciente_model.dart';
import '../models/consulta_model.dart';

class DatabaseHelper {
  // 🔹 Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  // 🔹 Nombre y versión de la base de datos
  static const _dbName = AppConstants.dbName;
  static const _dbVersion = 1;

  // 🔹 Obtener la base de datos
  Future<Database> get database async {
    if (_db != null) return _db!;

    // Inicialización FFI para escritorio
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _db = await _initDatabase();
    return _db!;
  }

  // 🔸 Inicializa la base de datos
  Future<Database> _initDatabase() async {
    final path = await _getDatabasePath();
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<String> _getDatabasePath() async {
    Directory dir;
    if (Platform.isAndroid || Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = Directory.current; // Escritorio: carpeta del ejecutable
    }
    return join(dir.path, _dbName);
  }

  // 🔸 Crear tablas
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pacientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cdr TEXT,
        num_casa TEXT,
        nombre TEXT NOT NULL,
        sexo TEXT,
        color_piel TEXT,
        dni TEXT,
        edad INTEGER,
        app TEXT,
        apf TEXT,
        alergias TEXT,
        operaciones TEXT,
        transfusiones TEXT,
        tratamiento TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE consultas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pacienteId INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        motivo TEXT,
        hea TEXT,
        sintomas TEXT,
        examen_fisico TEXT,
        diagnostico TEXT,
        estudios_indicados TEXT,
        estudios_recibidos TEXT,
        conducta TEXT,
        proxima_consulta TEXT,
        FOREIGN KEY (pacienteId) REFERENCES pacientes (id) ON DELETE CASCADE
      )
    ''');

    debugPrint('✅ Tablas creadas correctamente');
  }

  // 🔸 Actualización de versión
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS consultas');
    await db.execute('DROP TABLE IF EXISTS pacientes');
    await _onCreate(db, newVersion);
  }

  // ============================================================
  // 🧩 PACIENTES CRUD
  // ============================================================

  Future<int> insertPaciente(Paciente paciente) async {
    final db = await database;
    final data = {
      'cdr': paciente.cdr,
      'num_casa': paciente.numCasa,
      'nombre': paciente.nombre,
      'sexo': paciente.sexo,
      'color_piel': paciente.colorPiel,
      'dni': paciente.dni,
      'edad': paciente.edad,
      'app': paciente.app,
      'apf': paciente.apf,
      'alergias': paciente.alergias,
      'operaciones': paciente.operaciones,
      'transfusiones': paciente.transfusiones,
      'tratamiento': paciente.tratamiento,
    };
    return await db.insert('pacientes', data);
  }

  Future<int> updatePaciente(Paciente paciente) async {
    if (paciente.id == null) throw Exception('Paciente sin ID');
    final db = await database;
    final data = {
      'cdr': paciente.cdr,
      'num_casa': paciente.numCasa,
      'nombre': paciente.nombre,
      'sexo': paciente.sexo,
      'color_piel': paciente.colorPiel,
      'dni': paciente.dni,
      'edad': paciente.edad,
      'app': paciente.app,
      'apf': paciente.apf,
      'alergias': paciente.alergias,
      'operaciones': paciente.operaciones,
      'transfusiones': paciente.transfusiones,
      'tratamiento': paciente.tratamiento,
    };
    return await db.update('pacientes', data, where: 'id = ?', whereArgs: [paciente.id]);
  }

  Future<int> deletePaciente(int id) async {
    final db = await database;
    return await db.delete('pacientes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Paciente>> getPacientes() async {
    final db = await database;
    final result = await db.query('pacientes', orderBy: 'nombre ASC');
    return result.map((e) => Paciente.fromMap(e)).toList();
  }

  Future<Paciente?> getPacienteById(int id) async {
    final db = await database;
    final result = await db.query('pacientes', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return Paciente.fromMap(result.first);
    return null;
  }

  // ============================================================
  // 🩺 CONSULTAS CRUD
  // ============================================================

  Future<int> insertConsulta(Consulta consulta) async {
    final db = await database;
    final data = {
      'pacienteId': consulta.pacienteId,
      'fecha': consulta.fecha,
      'motivo': consulta.motivo,
      'hea': consulta.hea,
      'sintomas': consulta.sintomas,
      'examen_fisico': consulta.examenFisico,
      'diagnostico': consulta.diagnostico,
      'estudios_indicados': consulta.estudiosIndicados,
      'estudios_recibidos': consulta.estudiosRecibidos,
      'conducta': consulta.conducta,
      'proxima_consulta': consulta.proximaConsulta,
    };
    return await db.insert('consultas', data);
  }

  Future<List<Consulta>> getConsultasByPaciente(int pacienteId) async {
    final db = await database;
    final result = await db.query('consultas',
        where: 'pacienteId = ?', whereArgs: [pacienteId], orderBy: 'fecha DESC');
    return result.map((e) => Consulta.fromMap(e)).toList();
  }

  Future<int> updateConsulta(Consulta consulta) async {
    if (consulta.id == null) throw Exception('Consulta sin ID');
    final db = await database;
    final data = {
      'pacienteId': consulta.pacienteId,
      'fecha': consulta.fecha,
      'motivo': consulta.motivo,
      'hea': consulta.hea,
      'sintomas': consulta.sintomas,
      'examen_fisico': consulta.examenFisico,
      'diagnostico': consulta.diagnostico,
      'estudios_indicados': consulta.estudiosIndicados,
      'estudios_recibidos': consulta.estudiosRecibidos,
      'conducta': consulta.conducta,
      'proxima_consulta': consulta.proximaConsulta,
    };
    return await db.update('consultas', data, where: 'id = ?', whereArgs: [consulta.id]);
  }

  Future<int> deleteConsulta(int id) async {
    final db = await database;
    return await db.delete('consultas', where: 'id = ?', whereArgs: [id]);
  }

  // ============================================================
  // 💾 EXPORTAR / IMPORTAR BASE DE DATOS MULTIPLATAFORMA
  // ============================================================

  Future<File?> exportDatabase() async {
    try {
      final dbPath = await _getDatabasePath();
      final file = File(dbPath);

      if (!await file.exists()) {
        debugPrint('❌ No se encontró la base de datos para exportar');
        return null;
      }

      final exportDir = Platform.isAndroid || Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : Directory.current;

      final exportPath = join(exportDir.path, 'exported_$_dbName');
      final exportedFile = await file.copy(exportPath);

      debugPrint('📤 Base de datos exportada en: $exportPath');
      return exportedFile;
    } catch (e) {
      debugPrint('❌ Error exportando base de datos: $e');
      return null;
    }
  }

  Future<bool> importDatabase(File file) async {
    try {
      if (!await file.exists()) {
        debugPrint('❌ Archivo a importar no existe');
        return false;
      }

      final dbPath = await _getDatabasePath();
      await file.copy(dbPath);
      _db = await _initDatabase();
      debugPrint('📥 Base de datos importada correctamente');
      return true;
    } catch (e) {
      debugPrint('❌ Error importando base de datos: $e');
      return false;
    }
  }
}
