import 'package:flutter/material.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/components/shop_item_view.dart';

// class MyHomePage extends StatefulWidget {
class MyHomePage extends StatefulWidget {
	const MyHomePage({super.key, required this.title});

	final String title;

	@override
	State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	int _counter = 0;
	List<ShopItem> _items = [];

	void _addItem() {
		setState(() {
			_counter++;
			_items.add(ShopItem(name: 'new item $_counter'));
		});
	}

	void _removeItem(item) {
		int ix = -1;
		for(int i=0; i<_items.length; i++) {
			if(item == _items[i]) {
				ix = i;
				break;
			}
		}
		if( ix >= 0 ) {
			setState(() {
				_items.removeAt(ix);
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				title: Text(widget.title),
			),
			body: Center(
				child: ListView(
					children: _items.map((e) => ShopItemViewer(item: e, onRemoved: () =>_removeItem(e))).toList(),
				),
			),
			floatingActionButton: FloatingActionButton(
				onPressed: _addItem,
				tooltip: 'Metti in lista',
				child: const Icon(Icons.add_shopping_cart_rounded),
			), // This trailing comma makes auto-formatting nicer for build methods.
		);
	}
}
