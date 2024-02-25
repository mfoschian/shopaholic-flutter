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

	void _addItem(Product p) async {
    bool ok = await p.save();
    if(ok) {
      setState(() {
        _items.add(p);
      });
    }
	}


  Future<List<Product>> readProducts() async {
    _items = await Product.readItems();
    return _items;
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				title: const Text('widget.title'),
			),
			body: FutureBuilder(
        future: readProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: ListView(
                children: _items.map((e) => 
                  Row( children: [
                    GestureDetector(
                      child: ProductViewer(item: e),
                      onTap: () {
                        Navigator.pop(context, e);
                      }
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Product? p = await Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => EditItemPage(item: e)
                          )
                        );
                        if( p != null ) {
                          await p.save();
                          e.updateFrom(p);
                          setState(() {});
                        }
                      },
                      child: const Icon(Icons.edit)
                    )
                  ])
                ).toList(),
              ),
            );
          }
          else {
            return const CircularProgressIndicator();
          }
        },
      ),
			floatingActionButton: FloatingActionButton(
				onPressed: () async {
          Product? p = await Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => EditItemPage(item: Product(id: App.uuid(), name: ''))
            )
          );
          if( p == null ) return;
          _addItem(p);
        },
				tooltip: 'Aggiungi prodotto',
				child: const Icon(Icons.add),
			), // This trailing comma makes auto-formatting nicer for build methods.
		);
	}
}
