import 'dart:async';

// import 'package:shop_aholic/db/database.dart';
import 'package:shop_aholic/models/shop_item.dart';

class ShopList {

  List<ShopItem> items = [];

  void add(ShopItem item) {
    ShopItem? x = items.where((element) => element.item.id == item.item.id).firstOrNull;
    if( x == null ) {
      items.add(item);
    }
    else {
      x.qty++;
    }
  }

  bool del(ShopItem item, [int? qty]) {
    qty ??= item.qty;
    for(int i=0; i<items.length; i++) {
      if( items[i].item.id == item.item.id ) {
        if( items[i].qty > qty ) {
          items[i].qty -= qty;
        }
        else {
          items.removeAt(i);
        }
        return true;
      }
    }
    return false;
  }

  static ShopList? current;

  ShopList(List<ShopItem> l) : items = l;
  static Future<ShopList> read() async {
    current = ShopList(await ShopItem.readItems());
    return current!;
  }
}