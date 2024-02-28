import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


// import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // TODO: Comment on Android
void _initForLinux() {
  // databaseFactory = databaseFactoryFfi;  // TODO: Comment on Android
}

class SqliteDB {

  Database? _db;
  int version;
  String name;

  SqliteDB({required this.name, required this.version});

  Future<bool> execute(String sql, List<Object?>? args, Database? db) async {
    db ??= _db;
    if(db == null) {
      return Future.value(false);
    }

    await db.execute(sql, args);
    return true;  
  }

  Future<bool> executeStatements(List<String> statements, Database? db) async {
    db ??= _db;
    if(db == null) {
      return Future.value(false);
    }

    bool ok = (await Future.wait(statements.map( (sql) => execute(sql, null, db)), eagerError: true)).length == statements.length;
    return ok;  
  }


  List<String> createSchema(int version) { return []; }

  Future<bool> connect() async {

    _initForLinux();
    await close();

    String fullDbPath = join(await getDatabasesPath(),name);

    _db = await openDatabase(
      fullDbPath,
      onCreate: (db, version) => executeStatements(createSchema(version), db),
      version: version
    );
    return true;
  }
  
  Future<bool> close() async {
    if( _db != null ) {
      await _db!.close();
      _db = null;
    }
    return true;
  }

  Future<int> insert(String table, Map<String,Object?> values) {
    // returns: new id
    //const ConflictAlgorithm ca = ConflictAlgorithm.rollback;
    if( _db == null ) {
      return Future.value(0);
    }
    return _db!.insert(table, values);
  }

  Future<int> update(String table, Map<String,Object?> values, {String? where, List<Object?>? whereArgs}) {
    // returns: affected records
    //const ConflictAlgorithm ca = ConflictAlgorithm.rollback;
    if( _db == null ) {
      return Future.value(0);
    }
    return _db!.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) {
    // returns: new id
    //const ConflictAlgorithm ca = ConflictAlgorithm.rollback;
    if( _db == null ) {
      return Future.value(0);
    }
    return _db!.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String,Object?>>> query(String table, {
      bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}
  ) {
    if( _db == null ) return Future.value([]);

    return _db!.query(table, distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset
    );
  }

  Future<int> updateRaw(String sql, [List<Object?>? args]) async {
    if(_db==null) return Future.value(0);

    return _db!.rawUpdate(sql, args);
  }
  
  Future<int> insertRaw(String sql, [List<Object?>? args]) async {
    if(_db==null) return Future.value(0);

    return _db!.rawInsert(sql, args);
  }

  Future<List<Map<String,Object?>>> queryRaw(String sql, [List<Object?>? args] ) {
    if( _db == null ) return Future.value([]);

    return _db!.rawQuery(sql, args);
  }

}