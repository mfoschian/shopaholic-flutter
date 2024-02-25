import 'package:flutter/material.dart';
import 'package:shop_aholic/models/shop_list.dart';

class DoShoppingPage extends StatelessWidget {
  const DoShoppingPage({required this.list, super.key});

  final ShopList list;
  final String title = 'Vai!';

  List<Widget> widgets() {
    return list.items.map((e) => Text('${e.qty} - ${e.item.name}')).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.stop)
            )
          ]
        ),
        body: ListView(
          children: widgets(),
        ));
    // return const Placeholder();
  }
}
