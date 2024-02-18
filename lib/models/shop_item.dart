import "package:shop_aholic/models/known_item.dart";

class ShopItem {
  int qty;
  KnownItem item;
  bool done;

  ShopItem({required this.item, this.qty = 1, this.done = false });

  static Future<List<ShopItem>> readItems()  async {
    return [];
  }
}
