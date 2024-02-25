import 'package:flutter/material.dart';
import 'package:shop_aholic/models/product.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/pages/edit_item.dart';

class ShopItemViewer extends StatelessWidget {
  final ShopItem item;
  ShopItemViewer({super.key, required this.item, this.onRemoved, this.onEdit});

  Function? onRemoved;
  Function? onEdit;

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
            onLongPress: () { if( onEdit != null ) onEdit!(); },
            child: Text(item.item.name),
          ),
          ElevatedButton(
            onPressed: () { if( onRemoved != null ) onRemoved!(); },
            child: const Icon(Icons.remove_shopping_cart)
            )
        ]
      )
    );
  }
}