import 'package:flutter/material.dart';
import 'package:shop_aholic/components/product_viewer.dart';
import 'package:shop_aholic/models/shop_item.dart';

class ShopItemViewer extends StatelessWidget {
  final ShopItem item;
  const ShopItemViewer({super.key, required this.item, this.onLongTap});

  final Function? onLongTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              item.qty.toString(),
              textScaler: const TextScaler.linear(1.5),
            )
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: () { if( onLongTap != null ) onLongTap!(); },
              child: ProductViewer(item: item.product)
            ),
          )
        ]
      )
    );
  }
}