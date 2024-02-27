import 'package:flutter/material.dart';
import 'package:shop_aholic/app.dart';
import 'package:shop_aholic/components/product_viewer.dart';
import 'package:shop_aholic/models/product.dart';
import 'package:shop_aholic/pages/edit_item.dart';

class ChooseItemPage extends StatefulWidget {
  const ChooseItemPage({super.key});

  @override
  State<ChooseItemPage> createState() => _ChooseItemPageState();
}

class _ChooseItemPageState extends State<ChooseItemPage> {
  List<Product> _items = [];
  List<Product> _filteredItems = [];
  final TextEditingController _search = TextEditingController();
  bool _loaded = false;

  void _addItem(Product p) async {
    bool ok = await p.save();
    if (ok) {
      _items.add(p);
      _setFilteredItems(_search.text);
      setState(() {});
    }
  }

  void _setFilteredItems(String txt) {
    if(txt.isEmpty) {
      _filteredItems.clear();
    }
    else {
      final String ltxt = txt.toLowerCase();
      _filteredItems = _items.where( (p) => p.name.toLowerCase().contains(ltxt)).toList();
    }
    setState(() {});
  }

  Future<List<Product>> readProducts() async {
    _items = await Product.readItems();
    _loaded = true;
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Prodotti'),
      ),
      body: FutureBuilder(
        future: readProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done || _loaded) {
            return Column(children: [
              TextField(controller: _search, autofocus: true, onChanged: (value) => _setFilteredItems(value) ),
              Expanded(
                  child: ListView(
                      children: (_filteredItems.isEmpty ? _items : _filteredItems).map((e) => _rowItem(e, context)).toList()
                  )
              )
            ]);
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
                  builder: (context) =>
                      EditItemPage(item: Product(id: App.uuid(), name: ''))));
          if (p == null) return;
          _addItem(p);
        },
        tooltip: 'Aggiungi prodotto',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Row _rowItem(Product e, BuildContext context) {
    return Row(children: [
      GestureDetector(
          child: ProductViewer(item: e),
          onTap: () {
            Navigator.pop(context, e);
          }),
      ElevatedButton(
          onPressed: () async {
            Product? p = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditItemPage(item: e)));
            if (p != null) {
              await p.save();
              e.updateFrom(p);
              _setFilteredItems(_search.text); // refresh search
            }
          },
          child: const Icon(Icons.edit)
      )
    ]);
  }
}
