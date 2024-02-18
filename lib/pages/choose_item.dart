import 'package:flutter/material.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/components/shop_item_view.dart';

class ChooseItemPage extends StatefulWidget {
	const ChooseItemPage({super.key});


	@override
	State<ChooseItemPage> createState() => _ChooseItemPageState();
}

class _ChooseItemPageState extends State<ChooseItemPage> {

	List<ShopItem> _items = [];

	void _addItem() {
		setState(() {
		});
	}

	void _removeItem(item) {
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				title: const Text('widget.title'),
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
