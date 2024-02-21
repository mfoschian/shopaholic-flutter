import "package:shop_aholic/db/database.dart";
import "package:shop_aholic/models/product.dart";

class ShopItem {
  int qty;
  Product item;
  bool done;

  ShopItem({required this.item, this.qty = 1, this.done = false });

  static const String _tb = 'shopitems';

  static Future<List<ShopItem>> readItems()  async {
    List<Map<String,Object?>> rows = await DB.me().query(_tb);
    return [
      for (final {
            'sid': sid as int,
            'product_id': product_id as int,
            'qty': qty as int,
            'status': status as int,
          } in rows)
        ShopItem(
          qty:qty,
          done: status == 1,
          item: Product(
            id: 'p-$product_id',
            name: 'Prodotto $product_id'
          )
        )
    ];
  }
}