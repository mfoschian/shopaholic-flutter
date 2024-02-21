import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static const String _name = 'shopaholic.db';
  static const int _version = 1;

  final Database db;

  static void createSchema(Database db, int version) async {
    const List<String> statements = [
      """CREATE TABLE shop_points (
        id INTEGER PRIMARY KEY,
        name TEXT
      )""",
      """CREATE TABLE IF NOT EXISTS `products` (
        `id` TEXT NOT NULL, 
        `name` TEXT,
        `description` TEXT,
        `shopName` TEXT,
        `zoneName` TEXT,
        PRIMARY KEY(`id`)
      )""",
      """CREATE INDEX IF NOT EXISTS `index_products_name` ON `products` (`name`)""",
      """CREATE INDEX IF NOT EXISTS `index_products_shopName` ON `products` (`shopName`)""",
      """CREATE INDEX IF NOT EXISTS `index_products_zoneName` ON `products` (`zoneName`)""",

      """CREATE TABLE IF NOT EXISTS `shopitems` (
        `sid` TEXT NOT NULL,
        `product_id` TEXT,
        `qty` INTEGER NOT NULL,
        `status` INTEGER NOT NULL,
        PRIMARY KEY(`sid`)
      )""",
      """CREATE INDEX IF NOT EXISTS `index_shopitems_item_id` ON `shopitems` (`product_id`)""",
      """CREATE INDEX IF NOT EXISTS `index_shopitems_status` ON `shopitems` (`status`)""",
    ];

    bool ok = await execute(db, statements);
    if(!ok) {
      print('Schema creation failed');
    }

  }

  static Future<bool> execute(Database db, List<String> statements) async {
    bool ok = (await Future.wait(statements.map( (sql) => db.execute(sql)), eagerError: true)).length == statements.length;
    return ok;  
  }

  static Future<DB> create() async {

    WidgetsFlutterBinding.ensureInitialized();

    String fullDbPath = join(await getDatabasesPath(),_name);
    print('Opening $fullDbPath');

    Database db = await openDatabase(
      fullDbPath,
      onCreate: createSchema,
      version: _version
    );

    return DB(db: db);
  }

  DB({required this.db});

  Future<int> insert(String table, Map<String,Object?> values) {
    // returns: new id
    //const ConflictAlgorithm ca = ConflictAlgorithm.rollback;
    return db.insert(table, values);
  }

  static DB? _db = null;
  static DB me() {
    return _db!;
  }
  static Future<void> init() async {
    _db = await create();
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

    Database d = _db!.db;
    return d.query(table, distinct: distinct,
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
}