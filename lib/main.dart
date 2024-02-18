import 'package:flutter/material.dart';
import 'package:shop_aholic/pages/home.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() {
  runApp(MaterialApp(
    // debugShowCheckedModeBanner: false,
    title: 'ShopAholic',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: const MyHomePage(title: 'Home'), // becomes the route named '/'
    routes: <String, WidgetBuilder>{
      '/a': (BuildContext context) => const MyHomePage(title: 'page A'),
      '/b': (BuildContext context) => const MyHomePage(title: 'page B'),
      '/c': (BuildContext context) => const MyHomePage(title: 'page C'),
    },
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const MyHomePage(),
//     );
//   }
// }
