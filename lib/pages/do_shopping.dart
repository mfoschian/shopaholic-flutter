import 'package:flutter/material.dart';
import 'package:shop_aholic/components/product_viewer.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/models/shop_list.dart';

class DoShoppingPage extends StatefulWidget {
  const DoShoppingPage({required this.list, super.key});

  final ShopList list;
  final String title = 'ShopAholic - Spesa in corso';

  @override
  State<DoShoppingPage> createState() => _DoShoppingPageState();
}

class _DoShoppingPageState extends State<DoShoppingPage> {

  bool _showDone = true;
  static const Color _activeColor =  Color.fromARGB(255, 27, 195, 41);
  static const Color _doneColor =  Color.fromARGB(125, 155, 221, 160);

  List<ShopItem> get _visibleItems {
    return _showDone ? widget.list.items : widget.list.todoItems;
  }

  Widget _item(ShopItem e) {
    return GestureDetector( 
      onTap: () async {
        e.done = !e.done;
        await e.save();
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          e.done ?
            const Icon(Icons.check_circle, color:  _activeColor) :
            const Icon(Icons.radio_button_unchecked, color: _activeColor),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text( e.qty.toString(),
              textScaler: const TextScaler.linear(1.5),
              style: TextStyle(color: e.done ? _doneColor : null)
            ),
          ),
          Expanded(
            child: ProductViewer(item: e.product, color: e.done ? _doneColor : null)
          ),
        ]),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _showDone = !_showDone;
                });
              },
              icon: Icon(_showDone ? Icons.visibility : Icons.visibility_off)
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.stop)
            ),
          ]
        ),
        body: ListView.builder(
          itemCount: _visibleItems.length,
          itemBuilder: (context, index) => _item(_visibleItems[index]),
        ));
    // return const Placeholder();
  }
}
