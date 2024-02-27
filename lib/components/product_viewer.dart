import 'package:flutter/material.dart';
import 'package:shop_aholic/models/product.dart';

class ProductViewer extends StatelessWidget {
  final Product item;
  final Color? color;
  const ProductViewer({super.key, required this.item, this.color });

  List<Widget> _parts() {
    Widget name = Text(item.name,
      textScaler: const TextScaler.linear(1.5),
      style: TextStyle(color: color)
    );
    if( item.description == null || item.description!.isEmpty ) {
      return [name];
    }
    else {
      return [name, Text(item.description!, style: TextStyle(color: color))];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _parts()
    );
  }

}