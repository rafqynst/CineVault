

import '../database/app_database.dart';
import '../models/last_played_model.dart';

class LastPlayedRepository {
  final AppDatabase _database;

  LastPlayedRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  Future<void> saveLastPlayed(LastPlayedModel lastPlayed) async {
    final db = await _database.database;

    await db.transaction((txn) async {
      await txn.delete('last_played');

      await txn.insert('last_played', lastPlayed.toMap());
    });
  }

  Future<LastPlayedModel?> getLastPlayed() async {
    final db = await _database.database;

    final result = await db.query(
      'last_played',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return LastPlayedModel.fromMap(result.first);
  }

  Future<void> clearLastPlayed() async {
    final db = await _database.database;

    await db.delete('last_played', where: 'id = ?', whereArgs: [1]);
  }
}
