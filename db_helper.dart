import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper getInstance = DBHelper._();

  static const TABLE_NOTE = "note";
  static const COLUMN_NOTE_SNO = "s_no";
  static const COLUMN_NOTE_TITLE = "title";
  static const COLUMN_NOTE_DESC = "desc";

  Database? db;

  Future<Database> getDB() async {
    db ??= await openDB();
    return db!;
  }

  Future<Database> openDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "notes.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "create table $TABLE_NOTE("
          "$COLUMN_NOTE_SNO integer primary key autoincrement,"
          "$COLUMN_NOTE_TITLE text,"
          "$COLUMN_NOTE_DESC text)",
        );
      },
    );
  }

  Future<void> addNote({required String title, required String desc}) async {
    var dbClient = await getDB();
    await dbClient.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: title,
      COLUMN_NOTE_DESC: desc,
    });
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var dbClient = await getDB();
    return await dbClient.query(TABLE_NOTE);
  }

  Future<void> updateNote({
    required int id,
    required String title,
    required String desc,
  }) async {
    var dbClient = await getDB();
    await dbClient.update(
      TABLE_NOTE,
      {COLUMN_NOTE_TITLE: title, COLUMN_NOTE_DESC: desc},
      where: "$COLUMN_NOTE_SNO=?",
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(int id) async {
    var dbClient = await getDB();
    await dbClient.delete(
      TABLE_NOTE,
      where: "$COLUMN_NOTE_SNO=?",
      whereArgs: [id],
    );
  }
}
