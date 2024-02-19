import 'package:flutter/material.dart';
import 'package:shop_aholic/models/known_item.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({required this.item, super.key});

  final KnownItem item;
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