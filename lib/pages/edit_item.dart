import 'package:flutter/material.dart';
import 'package:shop_aholic/models/product.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({required this.item, super.key});

  final Product item;
  final String title = 'Modifica';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Text(item.name)
    );
    // return const Placeholder();
  }
}