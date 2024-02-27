import 'package:flutter/material.dart';
import 'package:shop_aholic/app.dart';
import 'package:shop_aholic/pages/home.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi;
  await App.db.connect();
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ShopAholic',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: const MyHomePage(title: 'ShopAHolic - Elenco Spesa'), // becomes the route named '/'
    // routes: <String, WidgetBuilder>{
    //   '/a': (BuildContext context) => const MyHomePage(title: 'page A'),
    //   '/b': (BuildContext context) => const MyHomePage(title: 'page B'),
    //   '/c': (BuildContext context) => const MyHomePage(title: 'page C'),
    // },
  ));
}
