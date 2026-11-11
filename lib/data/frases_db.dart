import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/frase.dart';

class FrasesDb {
  FrasesDb._();
  static final FrasesDb instancia = FrasesDb._();
  static const _nombreArchivo = "misfrases.db";
  static const _tabla = "frases";
  Database? _db;

  Future<Database> get dbAsync async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tabla (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            frase TEXT NOT NULL,
            autor TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertarFrase(Frase frase) async {
    final db = await dbAsync;
    return db.insert(_tabla, frase.toMap());
  }

  Future<List<Frase>> obtenerTodas() async {
    final db = await dbAsync;
    final filas = await db.query(_tabla, orderBy: 'id DESC');
    return filas.map((map) => Frase.fromMap(map)).toList();
  }

  Future<int> actualizarFrase(Frase frase) async {
    final db = await dbAsync;
    return db.update(
      _tabla,
      frase.toMap(),
      where: 'id = ?',
      whereArgs: [frase.id],
    );
  }

  Future<int> eliminarFrase(int id) async {
    final db = await dbAsync;
    return db.delete(_tabla, where: 'id = ?', whereArgs: [id]);
  }
}