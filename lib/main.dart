import 'package:flutter/material.dart';
import 'package:shop_aholic/app.dart';
import 'package:shop_aholic/pages/home.dart';


class _MyApp extends MaterialApp {

  _MyApp() : super(
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
  );
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await App.db.connect();
  
  runApp(_MyApp());
}



/*

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];

  @override
  void initState() {
    super.initState();

    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.getMediaStream().listen((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);

        print(_sharedFiles.map((f) => f.toMap()));
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.getInitialMedia().then((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        print(_sharedFiles.map((f) => f.toMap()));

        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.reset();
      });
    });
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyleBold = const TextStyle(fontWeight: FontWeight.bold);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ShopAHolic'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text("Shared files:", style: textStyleBold),
              Text(_sharedFiles
                  .map((f) => f.toMap())
                  .join(",\n****************\n")),
            ],
          ),
        ),
      ),
    );
  }
}


*/