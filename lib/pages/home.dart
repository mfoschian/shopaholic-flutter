import 'package:flutter/material.dart';
import 'package:shop_aholic/components/shop_item_view.dart';
import 'package:shop_aholic/models/known_item.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/models/shop_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // void _addItem(KnownItem ki) {
  void _addItem() {
    ShopList? items = ShopList.current;
    if (items == null) {
      return;
    }

    setState(() {
      KnownItem ki = KnownItem(id: '100', name: 'pippo');
      items.add(ShopItem(item: ki, qty: 1, done: false));
    });
  }

  void _removeItem(ShopItem it) {
    ShopList? items = ShopList.current;
    setState(() {
      items?.del(it);
    });
  }

  List<Widget> widgets() {
    ShopList? items = ShopList.current;
    if( items == null ) {
      return [];
    }
    else {
      return items.items.map((e) => ShopItemViewer(item: e, onRemoved: () => _removeItem(e))).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: FutureBuilder(
        future: ShopList.read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: ListView(
                children: widgets()
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Metti in lista',
        child: const Icon(Icons.add_shopping_cart_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
