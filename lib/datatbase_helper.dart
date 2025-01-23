import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? db;

  // Create the database
  static Future<void> createDB() async {
    if (db != null) return; // If the database already exists, skip creating it
    try {
      String path = "${await getDatabasesPath()}/notes.db";
      db = await openDatabase(
        path,
        version: 2, // Increment the version to enable upgrades
        onCreate: (db, version) async {
          await db.execute(
              "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, note TEXT, isFavorite INTEGER DEFAULT 0, isArchived INTEGER DEFAULT 0)");
          print('Database and tables created successfully');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute(
                "ALTER TABLE notes ADD COLUMN isArchived INTEGER DEFAULT 0");
            print('Database upgraded: isArchived column added');
          }
        },
      );
    } catch (e) {
      print('Database creation error: $e');
    }
  }

  // Insert new data
  static Future<void> insertDB(String title, String note) async {
    try {
      await db?.insert('notes', {
        'title': title,
        'note': note,
        'isFavorite': 0, // Default value
        'isArchived': 0, // Default value
      });
      print('Data inserted successfully');
    } catch (e) {
      print('Insert error: $e');
    }
  }

  // Fetch all data
  static Future<List<Map<String, dynamic>>?> getDataFromDB() async {
    try {
      final data = await db?.query("notes");
      print('Data fetched from the database: $data');
      return data;
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  // Update favorite status
  static Future<void> updateFavoriteStatus(int id, int isFavorite) async {
    try {
      await db?.update(
        'notes',
        {'isFavorite': isFavorite}, // Update the isFavorite column
        where: 'id = ?', // Match the note by ID
        whereArgs: [id],
      );
      print('Favorite status updated successfully');
    } catch (e) {
      print('Error updating favorite status: $e');
    }
  }

  // Fetch favorite notes
  static Future<List<Map<String, dynamic>>?> getFavoriteNotes() async {
    try {
      return await db?.query("notes", where: "isFavorite = ?", whereArgs: [1]);
    } catch (e) {
      print('Error fetching favorite notes: $e');
      return null;
    }
  }

  // Update archive status
  static Future<void> updateNoteStatus(int id, bool isArchived) async {
    try {
      await db?.update(
        'notes',
        {'isArchived': isArchived ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Archive status updated successfully');
    } catch (e) {
      print('Update error: $e');
    }
  }

  // Delete a note
  static Future<void> deleteNote(int id) async {
    try {
      await db?.delete('notes', where: 'id = ?', whereArgs: [id]);
      print('Note deleted successfully');
    } catch (e) {
      print('Delete error: $e');
    }
  }

  // Fetch archived notes
  static Future<List<Map<String, dynamic>>> getArchivedNotes() async {
    try {
      final list =
          await db?.query('notes', where: 'isArchived = ?', whereArgs: [1]);
      print('Archived notes fetched: $list');
      return list ?? [];
    } catch (e) {
      print('Error fetching archived notes: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> searchNotes(String query) async {
    try {
      final data = await db?.query(
        'notes',
        where: 'title LIKE ?', // Search only in the 'title' column
        whereArgs: ['%$query%'], // Use the query parameter with wildcards
      );
      print('Search results: $data');
      return data ?? [];
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getNoteById(int id) async {
    try {
      final data = await db?.query(
        'notes',
        where: 'id = ?',
        whereArgs: [id],
      );
      return data?.isNotEmpty == true ? data!.first : null;
    } catch (e) {
      print('Error fetching note by ID: $e');
      return null;
    }
  }

  static Future<void> updateNote(
      int id, String title, String description) async {
    try {
      await db?.update(
        'notes',
        {
          'title': title,
          'note': description,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Note updated successfully');
    } catch (e) {
      print('Error updating note: $e');
    }
  }
}
