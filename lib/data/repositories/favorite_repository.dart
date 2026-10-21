import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';

class FavoriteRepository {
  final AppDatabase _appDatabase;

  FavoriteRepository(this._appDatabase);

  Future<List<Map<String, Object?>>> getFavorites() async {
    final db = await _appDatabase.database;

    return db.query('favorites', orderBy: 'added_at DESC');
  }

  Future<void> addFavorite({
    required String videoId,
    required String videoPath,
    required String videoName,
  }) async {
    final db = await _appDatabase.database;

    await db.insert('favorites', {
      'video_id': videoId,
      'video_path': videoPath,
      'video_name': videoName,
      'added_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(String videoId) async {
    final db = await _appDatabase.database;

    await db.delete('favorites', where: 'video_id = ?', whereArgs: [videoId]);
  }

  Future<bool> isFavorite(String videoId) async {
    final db = await _appDatabase.database;

    final result = await db.query(
      'favorites',
      columns: ['video_id'],
      where: 'video_id = ?',
      whereArgs: [videoId],
      limit: 1,
    );

    return result.isNotEmpty;
  }
}
