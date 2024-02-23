import 'package:flutter/material.dart';
import 'package:shop_aholic/models/product.dart';

class ProductViewer extends StatelessWidget {
  final Product item;
  const ProductViewer({super.key, required this.item });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.all(10), child: Text(item.name)),
          Padding(padding: const EdgeInsets.all(10), child: Text(item.description ?? '')),
        ]
      )
    );
  }
}