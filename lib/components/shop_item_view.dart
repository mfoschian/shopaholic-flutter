import 'package:flutter/material.dart';
import 'package:shop_aholic/models/shop_item.dart';

class ShopItemViewer extends StatelessWidget {
  final ShopItem item;
  const ShopItemViewer({super.key, required this.item, required this.onRemoved});

  final Function onRemoved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text(item.name),
          ElevatedButton(
            onPressed: () => onRemoved(),
            child: const Icon(Icons.delete)
            )
        ]
      )
    );
  }
}