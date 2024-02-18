import 'package:flutter/material.dart';
import 'package:shop_aholic/models/shop_item.dart';

class ShopItemViewer extends StatelessWidget {
  final ShopItem item;
  const ShopItemViewer({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(item.name)
    );
  }
}