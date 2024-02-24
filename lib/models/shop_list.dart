import 'dart:async';

// import 'package:shop_aholic/db/database.dart';
import 'package:shop_aholic/models/product.dart';
import 'package:shop_aholic/models/shop_item.dart';

class ShopList {

  List<ShopItem> items = [];

  Future<void> add(Product p, [int qty=1]) async {
    ShopItem? x = items.where((element) => element.item.id == p.id).firstOrNull;
    if( x == null ) {
      ShopItem x = ShopItem(item:p, qty:qty, done:false);
      await x.save();
      items.add(x);
    }
    else {
      x.qty++;
      x.done = false;
      await x.save();
    }
  }

  void del(Product p, [int qty = 1]) async {
    for(int i=0; i<items.length; i++) {
      if( items[i].item.id == p.id ) {
        if( items[i].qty > qty ) {
          items[i].qty -= qty;
        }
        else {
          await  items[i].del();
          items.removeAt(i);
        }
        break;
      }
    }
  }

  ShopList(List<ShopItem> l) : items = l;

  static Future<ShopList> read() async {
    return ShopList(await ShopItem.readItems());
  }
}