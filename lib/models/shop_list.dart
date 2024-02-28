import 'dart:async';

// import 'package:shop_aholic/db/database.dart';
import 'package:shop_aholic/models/product.dart';
import 'package:shop_aholic/models/shop_item.dart';

class ShopList {

  ShopList(List<ShopItem> l) : items = l;

  List<ShopItem> items = [];
  List<ShopItem> get todoItems {
    return items.where( (i) => i.done == false ).toList();
  }

  List<ShopItem> get doneItems {
    return items.where( (i) => i.done == true ).toList();
  }

  Future<void> add(Product p, [int qty=1]) async {
    ShopItem? x = items.where((element) => element.product.id == p.id).firstOrNull;
    if( x == null ) {
      ShopItem x = ShopItem(product:p, qty:qty, done:false);
      await x.save();
      items.add(x);
    }
    else {
      x.qty++;
      x.done = false;
      await x.save();
    }
  }

  Future<void> del(Product p, [int qty = 1]) async {
    for(int i=0; i<items.length; i++) {
      if( items[i].product.id == p.id ) {
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

  Future<void> clear() async {
    for( ShopItem itm in items) {
      await itm.del();
    }
    items.clear();
  }

  static Future<ShopList> read() async {
    return ShopList(await ShopItem.readItems());
  }
}