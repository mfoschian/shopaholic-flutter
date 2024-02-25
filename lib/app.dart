import 'package:shop_aholic/db/database.dart';
import 'package:uuid/uuid.dart';

class App {

  static const Uuid _uuid = Uuid();

  static DB? _db;
  static DB get db {
    _db ??= DB();
    return _db!;
  }

  static String uuid() {
    return _uuid.v4();
  }

  static Future<void> importProducts() {
    return Future.value();
  }

}