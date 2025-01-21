import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? db;

  static Future<void> createDB() async {
    if (db != null) return;
    try {
      String path = "${await getDatabasesPath()}/notes.db";
      db = await openDatabase(path, version: 1, onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, note TEXT, isFavorite INTEGER Default 0)");
        print('Database and table created successfully');
      });
    } catch (e) {
      print('Database creation error: $e');
    }
  }

  static Future<void> insertDB(String title, String note) async {
    try {
      await DBHelper.db!.insert('notes', {'title': title, 'note': note});
    } catch (e) {
      print('Insert error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>?> getDataFromDB() async {
    try {
      final data = await db?.query("notes");
      print('Data from DB: $data'); // Debug log
      return data;
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  static Future<void> updateFavoriteStatus(int id, bool isFavorite) async {
    try {
      await db?.update(
        'notes',
        {'isFavorite': isFavorite ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Update error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>?> getFavoriteNotes() async {
    try {
      return await db?.query("notes", where: "isFavorite = ?", whereArgs: [1]);
    } catch (e) {
      print('Update error: $e');
    }
  }
}
