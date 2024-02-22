import 'package:shop_aholic/db/database.dart';

class App {

  static DB? _db;
  static DB get db {
    _db ??= DB();
    return _db!;
  }


}