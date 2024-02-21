import 'package:flutter/material.dart';
import 'package:shop_aholic/models/product.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/pages/edit_item.dart';

class ShopItemViewer extends StatelessWidget {
  final ShopItem item;
  const ShopItemViewer({super.key, required this.item, required this.onRemoved});

  final Function onRemoved;

  goToEditPageFor(Product it) {
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.all(10), child: Text(item.qty.toString())),
          GestureDetector(
            onLongPress: () => {
              // Navigator.of(context).push(route)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditItemPage(item: item.item)
                )
              )
            },
            child: Text(item.item.name),
          ),
          ElevatedButton(
            onPressed: () => onRemoved(),
            child: const Icon(Icons.remove_shopping_cart)
            )
        ]
      )
    );
  }
}