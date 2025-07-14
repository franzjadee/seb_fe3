import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/bug.dart';

class BugDatabase {
  static final BugDatabase instance = BugDatabase._init();
  static Database? _database;

  BugDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bugtracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bugs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectName TEXT,
        bugType TEXT,
        severity TEXT,
        isResolved INTEGER
      )
    ''');
  }

  Future<int> addBug(Bug bug) async {
    final db = await instance.database;
    return await db.insert('bugs', bug.toMap());
  }

  Future<List<Bug>> getBugs() async {
    final db = await instance.database;
    final result = await db.query('bugs');
    return result.map((map) => Bug.fromMap(map)).toList();
  }

  Future<int> updateBug(Bug bug) async {
    final db = await instance.database;
    return await db.update('bugs', bug.toMap(), where: 'id = ?', whereArgs: [bug.id]);
  }

  Future<int> deleteBug(int id) async {
    final db = await instance.database;
    return await db.delete('bugs', where: 'id = ?', whereArgs: [id]);
  }
}