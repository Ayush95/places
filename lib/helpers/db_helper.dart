import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBhelper {
  static Future<sql.Database> database() async {
    final dbpath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbpath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBhelper.database();
    db.insert(
      table,
      data,
    );
  }

  static Future<List<Map<String, dynamic>>> getdata(String table) async {
    final db = await DBhelper.database();
    return db.query(table);
  }
}
