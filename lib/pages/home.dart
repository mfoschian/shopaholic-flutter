import 'dart:convert';
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

  ShopList? list;
  bool _needReload = true;
  List<ShopItem> get _safeList {
    return list == null ? [] : list!.items;
  }

  // void _addItem(Product ki) {
  void _addItem(Product p) async {
    if (list == null) return;
    await list!.add(p, 1);

    setState(() {});
  }

  void _delItem(ShopItem it) {
    if (list == null) return;
    setState(() {
      list!.del(it.product, it.qty);
    });
  }

  Future<void> _doEditFor(ShopItem s, {String? title}) async {            // Navigator.of(context).push(route)
    Product? p = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(item: s.product, title: title ?? 'Modifica Prodotto')
      )
    );
    if(p!=null) {
      await p.save();
      s.product.updateFrom(p);
      setState(() {});
    }
  }

  Widget _item(ShopItem e) {
    return Row(
      children: [
        GestureDetector(
          child: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.add_circle, color: Colors.greenAccent)
          ),
          onTap:() async {
            e.qty += 1;
            await e.save();
            setState(() {});
          },
        ),
        Expanded( child: ShopItemViewer(
            item: e,
            onLongTap: () async { await _doEditFor(e, title: 'Modifica Prodotto'); } 
          )
        ),
        GestureDetector(
          child: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.remove_circle, color: Colors.redAccent)
          ),
          onTap:() async {
            if(e.qty > 1) {
              e.qty -= 1;
              await e.save();
              setState(() {});
            }
            else if( e.qty == 1 ) {
              _delItem(e);
            }
          },
        ),
      ]
    );
  }

  Future loadData() async {
    list = await ShopList.read();
    _needReload = false;
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
    List<dynamic> itms = o["list"];
    for( dynamic item in itms ) {
      Product p = Product.fromJson(item);
      await p.save();
    }
    setState(() {
      _needReload = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoShoppingPage(list: list!)
                )
              )
            },
            icon: const Icon(Icons.play_arrow)
          )
        ],
      ),
      drawer: MyDrawerMenu(
        onImport: () async {
          await doImport();
        },
      ),
      body: _needReload ? FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _body();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ) : _body(),
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

  Widget _body() {
    return Center(
      child: ListView.builder(
        itemCount: _safeList.length,
        itemBuilder: (context, index) => Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.3,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) =>_delItem(_safeList[index]),
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Elimina'
              )
            ]
          ),
          endActionPane: ActionPane(
            extentRatio: 0.3,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _doEditFor(_safeList[index]),
                backgroundColor: const Color.fromARGB(255, 17, 210, 49),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Modifica'
              )
            ]
          ),
          child: _item(_safeList[index]),
        )
      ),
    );
  }
}
