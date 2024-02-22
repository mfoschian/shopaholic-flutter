import 'package:shop_aholic/db/sqlite_db.dart';


class DB extends SqliteDB {
  static const String _name = 'shopaholic.db';
  static const int _version = 1;

  DB() : super(name: _name, version: _version);

  @override
  List<String> createSchema(int version) {
    return [
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
  }

}