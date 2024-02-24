import 'package:flutter/material.dart';
import 'package:shop_aholic/components/shop_item_view.dart';
import 'package:shop_aholic/models/product.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/models/shop_list.dart';
import 'package:shop_aholic/pages/choose_item.dart';
import 'package:shop_aholic/pages/do_shopping.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ShopList? items;

  // void _addItem(Product ki) {
  void _addItem(Product p) {
    if (items == null) return;

    setState(() {
      items!.add(p, 1);
    });
  }

  void _delItem(ShopItem it) {
    if (items == null) return;
    setState(() {
      items!.del(it.item, it.qty);
    });
  }

  List<Widget> widgets() {
    if( items == null ) {
      return [];
    }
    else {
      return items!.items.map((e) => ShopItemViewer(item: e, onRemoved: () => _delItem(e))).toList();
    }
  }

  Future loadData() async {
    items = await ShopList.read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton.icon(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoShoppingPage(list: items!)
                )
              )
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('go')
            )
          ]
      ),

      body: FutureBuilder(
        future: loadData(),
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
        // onPressed: _addItem,
        onPressed: () async {
          Product p = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChooseItemPage()
            )
          );
          if(items == null) return;

          await items!.add(p, 1);
          setState(() {});                
        },
        tooltip: 'Metti in lista',
        child: const Icon(Icons.add_shopping_cart_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
