
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();

  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'cinevault.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createLastPlayedTable(db);
    await _createFavoritesTable(db);
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await _createFavoritesTable(db);
    }
  }

  Future<void> _createLastPlayedTable(Database db) async {
    await db.execute('''
      CREATE TABLE last_played (
        id INTEGER PRIMARY KEY,
        video_id TEXT NOT NULL,
        video_path TEXT NOT NULL,
        video_name TEXT NOT NULL,
        position INTEGER NOT NULL,
        duration INTEGER NOT NULL,
        last_played TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createFavoritesTable(Database db) async {
    await db.execute('''
      CREATE TABLE favorites (
        video_id TEXT PRIMARY KEY,
        video_path TEXT NOT NULL,
        video_name TEXT NOT NULL,
        added_at TEXT NOT NULL
      )
    ''');
  }
}
