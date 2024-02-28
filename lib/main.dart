import 'package:flutter/material.dart';
import 'package:shop_aholic/app.dart';
import 'package:shop_aholic/pages/home.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
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
