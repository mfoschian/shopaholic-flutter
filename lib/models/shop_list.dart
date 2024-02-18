import 'dart:async';

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

  static Future<ShopList> read() async {
    current ??= ShopList();
    
    // TODO: async read from db
    return Future.delayed(const Duration(seconds: 3), () => Future.value(current));
  }
}