import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shop_aholic/components/drawer_menu.dart';
import 'package:shop_aholic/components/shop_item_view.dart';
import 'package:shop_aholic/models/product.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/models/shop_list.dart';
import 'package:shop_aholic/pages/choose_item.dart';
import 'package:shop_aholic/pages/do_shopping.dart';
import 'package:shop_aholic/pages/edit_item.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ShopList? items;

  // void _addItem(Product ki) {
  void _addItem(Product p) async {
    if (items == null) return;
    await items!.add(p, 1);

    setState(() {});
  }

  void _delItem(ShopItem it) {
    if (items == null) return;
    setState(() {
      items!.del(it.product, it.qty);
    });
  }

  List<Widget> widgets(BuildContext context) {
    if( items == null ) {
      return [];
    }
    else {
      return items!.items.map((e) => ShopItemViewer(item: e,
        onRemoved: () => _delItem(e),
        onEdit: () async {            // Navigator.of(context).push(route)
            Product? p = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditItemPage(item: e.product)
              )
            );
            if(p!=null) {
              await p.save();
              e.product.updateFrom(p);
              setState(() {});
            }
          }
        )
      ).toList();
    }
  }

  Future loadData() async {
    items = await ShopList.read();
  }

  Future<void> doImport() async {
    FilePickerResult? res = await FilePicker.platform.pickFiles();
    if(res == null) {
      return;
    }

    String filePath = res.files.single.path!;
    File file = File(filePath);
    String json = await file.readAsString();

    Map<String, dynamic> o = jsonDecode(json);
    List<dynamic> items = o["items"];
    for( dynamic item in items ) {
      Product p = Product.fromJson(item);
      await p.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoShoppingPage(list: items!)
                )
              )
            },
            child: const Icon(Icons.play_arrow)
          )
        ],
      ),
      drawer: MyDrawerMenu(
        onImport: () async {
          await doImport();
        },
      ),
      body: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: ListView(
                children: widgets(context).map( (w) => Slidable(
                  startActionPane: ActionPane(
                    extentRatio: 0.3,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) =>_delItem((w as ShopItemViewer).item),
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Elimina'
                      )
                    ]),
                  child: w,
                )).toList(),
              )
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Product? p = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChooseItemPage()
            )
          );
          if(p != null) {
            _addItem(p);
          }
        },
        tooltip: 'Metti in lista',
        child: const Icon(Icons.add_shopping_cart_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
