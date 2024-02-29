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
              // const MaxGap(10),
              _searchBox(),
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
                      EditItemPage(item: Product(id: App.uuid(), name: ''), title: 'Nuovo Prodotto')));
          if (p == null) return;
          _addItem(p);
        },
        tooltip: 'Aggiungi prodotto',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextField(
        controller: _search,
        decoration: const InputDecoration(
          labelText:'Cerca',
          // icon: Icon(Icons.search),
          border: OutlineInputBorder()
        ),
        autofocus: true,
        onChanged: (value) => _setFilteredItems(value)
      )
    );
  }

  Widget _rowItem(Product e, BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8),child: 
      Row(children: [
        Expanded(child: 
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: ProductViewer(item: e),
              onTap: () {
                Navigator.pop(context, e);
              }),
        ),
        GestureDetector(
            onTap: () async {
              Product? p = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditItemPage(item: e, title: 'Modifica Prodotto')));
              if (p != null) {
                await p.save();
                e.updateFrom(p);
                _setFilteredItems(_search.text); // refresh search
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.edit)
            )
        )
      ])
    );
  }
}
