import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modelos/alumno.dart';

class GestorBaseDatos {
  GestorBaseDatos._();
  static final instancia = GestorBaseDatos._();

  Database? _db;

  Future<Database> _abrir() async {
    if (_db != null) return _db!;
    String ruta = join(await getDatabasesPath(), "alumnos.db");

    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE alumnos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            numeroControl TEXT UNIQUE,
            nombre TEXT,
            apellidoPaterno TEXT,
            apellidoMaterno TEXT,
            telefono TEXT,
            correo TEXT
          )
        """);
      },
    );

    return _db!;
  }

  // ⬅ MÉTODO QUE TE FALTABA
  Future<bool> existeNumeroControl(String nc) async {
    final db = await _abrir();

    final res = await db.query(
      "alumnos",
      where: "numeroControl = ?",
      whereArgs: [nc],
    );

    return res.isNotEmpty;
  }

  Future<int> insertarAlumno(Alumno a) async {
    final db = await _abrir();

    // evitar duplicados
    final existe = await db.query(
      "alumnos",
      where: "numeroControl = ?",
      whereArgs: [a.numeroControl],
    );

    if (existe.isNotEmpty) return -1;

    return await db.insert("alumnos", a.toMap());
  }

  Future<int> actualizarAlumno(Alumno a) async {
    final db = await _abrir();
    return await db.update(
      "alumnos",
      a.toMap(),
      where: "id = ?",
      whereArgs: [a.id],
    );
  }

  Future<int> eliminarAlumno(int id) async {
    final db = await _abrir();
    return await db.delete("alumnos", where: "id = ?", whereArgs: [id]);
  }

  Future<List<Alumno>> listarAlumnos() async {
    final db = await _abrir();
    final res = await db.query("alumnos", orderBy: "nombre ASC");
    return res.map((e) => Alumno.fromMap(e)).toList();
  }

  Future<List<Alumno>> buscar(String texto) async {
    final db = await _abrir();
    final res = await db.query(
      "alumnos",
      where: "nombre LIKE ? OR numeroControl LIKE ?",
      whereArgs: ["%$texto%", "%$texto%"],
    );
    return res.map((e) => Alumno.fromMap(e)).toList();
  }
}