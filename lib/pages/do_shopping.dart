import 'package:flutter/material.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/models/shop_list.dart';

class DoShoppingPage extends StatefulWidget {
  const DoShoppingPage({required this.list, super.key});

  final ShopList list;
  final String title = 'ShopAholic';

  @override
  State<DoShoppingPage> createState() => _DoShoppingPageState();
}

class _DoShoppingPageState extends State<DoShoppingPage> {

  bool _showDone = true;

  List<Widget> widgets() {
    List<ShopItem> its = _showDone ? widget.list.items : widget.list.todoItems;
      return its.map((e) =>
        GestureDetector( 
          onTap: () async {
            e.done = !e.done;
            await e.save();
            setState(() {});
          },
          child: Text('${e.qty} - ${e.product.name} - ${e.done ? 'X' : ''}'),
        )
      ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showDone = !_showDone;
                });
              },
              child: Icon(_showDone ? Icons.remove_red_eye : Icons.arrow_back)
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.stop)
            ),
          ]
        ),
        body: ListView(
          children: widgets(),
        ));
    // return const Placeholder();
  }
}
