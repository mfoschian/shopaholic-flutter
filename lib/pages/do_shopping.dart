import 'package:flutter/material.dart';
import 'package:shop_aholic/components/product_viewer.dart';
import 'package:shop_aholic/models/shop_item.dart';
import 'package:shop_aholic/models/shop_list.dart';
import 'package:badges/badges.dart' as badges;

class DoShoppingPage extends StatefulWidget {
  const DoShoppingPage({required this.list, super.key});

  final ShopList list;
  final String title = 'ShopAholic - Spesa in corso';

  @override
  State<DoShoppingPage> createState() => _DoShoppingPageState();
}

class _ShopStats {
  final String shopName;
  int products;
  int done;

  _ShopStats(String name) : shopName = name, products = 0, done = 0;
}

class _DoShoppingPageState extends State<DoShoppingPage> {

  bool _showDone = true;
  static const Color _activeColor =  Color.fromARGB(255, 27, 195, 41);
  static const Color _doneColor =  Color.fromARGB(125, 155, 221, 160);
  static const String _unknownShop = 'Altro';

  List<ShopItem> get _visibleItems {
    return _showDone ? widget.list.items : widget.list.todoItems;
  }

  List<_ShopStats> get _shops {
    final Map<String,_ShopStats> stats = {};
    for( ShopItem itm in widget.list.items) {
      final String shopName = itm.product.shopName ?? _unknownShop;
      _ShopStats s = stats.putIfAbsent(shopName, () => _ShopStats(shopName));
      s.products += 1;
      if(itm.done) s.done += 1;
    }
    List<_ShopStats> ss = stats.values.toList();
    // La sparizione delle tab causa problemi di setState e dispose()
    // Per il momento faccio vedere anche quelle completate
    // if(!_showDone) {
    //   ss = ss.where( (s) => s.done < s.products ).toList();
    // }
    ss.sort((a,b) => a.shopName.compareTo(b.shopName));
    return ss;
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

    final List<_ShopStats> shops = _shops;

    return DefaultTabController(
      length: shops.length,
      initialIndex: 0,
      child: Scaffold(
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
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: shops.map((s) => 
              badges.Badge(
                // position: badges.BadgePosition.topEnd(top: -20, end: -12),
                badgeContent: Text('${s.done}/${s.products}'),
                badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 200)),
                badgeStyle: badges.BadgeStyle(badgeColor: s.done == s.products ? Colors.green : Colors.orange ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(s.shopName, textScaler: const TextScaler.linear(1.5))
                )
              )
            ).toList()
          )
        ),
        body: TabBarView(
          children: shops.map( (s) {
            List<ShopItem> shopItems = _visibleItems.where( (e) => (e.product.shopName ?? _unknownShop) == s.shopName ).toList();
            return ListView.builder(
              itemCount: shopItems.length,
              itemBuilder: (context, index) => _item(shopItems[index]),
            );
          }).toList()
        )
      )
    );
  }
}
