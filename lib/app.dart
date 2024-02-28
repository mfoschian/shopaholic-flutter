import 'dart:io';
import 'dart:convert';

import 'package:shop_aholic/db/database.dart';
import 'package:shop_aholic/models/product.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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



  static Future<void> importProducts() async {
    FilePickerResult? res = await FilePicker.platform.pickFiles();
    if(res == null) {
      return;
    }

    String filePath = res.files.single.path!;
    File file = File(filePath);
    String json = await file.readAsString();

    Map<String, dynamic> o = jsonDecode(json);
    List<dynamic> itms = o["items"];
    for( dynamic item in itms ) {
      Product p = Product.fromJson(item);
      await p.save();
    }
  }

  static Future<String?> exportProducts() async {

    List<Product> items = await Product.readItems();

    Map<String, dynamic> o = { "items": items.map( (p) => p.toJson() ).toList() };
    String json = jsonEncode(o);

    final Directory? downloadsDir = await getDownloadsDirectory();
    if(downloadsDir == null) {
      return null; // throw "Cannot save !"
    }

    DateTime now = DateTime.now();
    const String baseName = 'shopaholic.json';
    String fileName = "${now.year.toString()}${now.month.toString().padLeft(2,'0')}${now.day.toString().padLeft(2,'0')}_${now.hour.toString().padLeft(2,'0')}${now.minute.toString().padLeft(2,'0')}${now.second.toString().padLeft(2,'0')}_$baseName";
    String filePath = path.join(downloadsDir.path, fileName);
    File file = File(filePath);
    await file.writeAsString(json);

    return filePath;
  }

}