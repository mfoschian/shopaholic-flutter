import 'package:flutter/material.dart';
import 'package:shop_aholic/app.dart';
import 'package:shop_aholic/components/product_viewer.dart';
import 'package:shop_aholic/models/product.dart';


class ChooseItemPage extends StatefulWidget {
	const ChooseItemPage({super.key});


	@override
	State<ChooseItemPage> createState() => _ChooseItemPageState();
}

class _ChooseItemPageState extends State<ChooseItemPage> {

	List<Product> _items = [];

	void _addItem() async {
    // TODO: goto new Product page
    Product p = Product(id: App.uuid(), name: 'Product One', description: 'The first Product');
    bool ok = await p.save();
    if(ok) {
      setState(() {
        _items.add(p);
      });
    }
	}

	void _removeItem(item) {
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
                  GestureDetector(
                    child: ProductViewer(item: e),
                    onTap: () {
                        Navigator.pop(context, e);
                    }

                  )
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
				onPressed: _addItem,
				tooltip: 'Aggiungi prodotto',
				child: const Icon(Icons.add),
			), // This trailing comma makes auto-formatting nicer for build methods.
		);
	}
}
