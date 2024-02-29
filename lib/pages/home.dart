

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:shop_aholic/app.dart';
import 'package:shop_aholic/components/drawer_menu.dart';
import 'package:shop_aholic/components/progress_dialog.dart';
import 'package:shop_aholic/components/shop_item_view.dart';
import 'package:shop_aholic/models/product.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/models/shop_list.dart';
import 'package:shop_aholic/pages/choose_item.dart';
import 'package:shop_aholic/pages/do_shopping.dart';
import 'package:shop_aholic/pages/edit_item.dart';
import 'package:shop_aholic/shoplist_listener.dart';

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

  // Intent Management {
  final ShopListListener _listener = ShopListListener();

  @override
  void initState() {
    super.initState();

    // Listen to media sharing coming from outside the app while the app is in the memory.
    _listener.start(onLoaded: () => setState(() { _needReload = true; } ));
  }

  @override
  void dispose() {
    _listener.stop();
    super.dispose();
  }
  // } Intent Management

  // void _addItem(Product ki) {
  Future<void> _addItem(Product p) async {
    if (list == null) return;
    await list!.add(p, 1);

    setState(() {});
  }

  Future<void> _delItem(ShopItem it) async {
    if (list != null) {
      await list!.del(it.product, it.qty);

      setState(() {});
    }
  }

  Future<void> _doEditFor(ShopItem s, {String? title}) async {
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
              await _delItem(e);
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
    ProgressDialog<void> modal = ProgressDialog<void>(title: 'Import', message: 'Import dati in corso');
    await modal.open(context, App.importProducts);

  }

  Future<String?> doExport() async {
    ProgressDialog<String?> modal = ProgressDialog<String?>(title: 'Export', message: 'Export dati in corso');
    String? path = await modal.open(context, App.exportProducts);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              App.shareList().then( (ok) {
                final String message = ok ? 'Spesa condivisa!' : 'Ops! Qualcosa è andato storto';
                SnackBar snackBar = SnackBar( content: Text(message));

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);              
              });
            },
            icon: const Icon(Icons.share)
          ),
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
          doImport()
            .then( (res) => setState(() {_needReload = true;}) )
            .onError((error, stackTrace) {
              SnackBar snackBar = SnackBar( content: Text('Errore!\n${error.toString()}'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
        },
        onExport: () {
          doExport().then( (path) {
            if(path != null) {
              SnackBar snackBar = SnackBar( content: Text('Export in $path'));

              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          });
        },
        onNewShopping: () async {
          if(list == null || list!.items.isEmpty) return;

          bool ok = await confirm(
            context,
            title: const Text('Attenzione !'),
            content: const Text('Iniziare una nuova spesa cancella la vecchia !'),
            textOK: const Text('OK, cancella'),
            textCancel: const Text('NO, non cancellare'),
          );
          
          if(ok == true) {
            await list!.clear();
            setState(() { _needReload = true; });
          }
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
            await _addItem(p);
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
                onPressed: (context) async { await _delItem(_safeList[index]); },
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
