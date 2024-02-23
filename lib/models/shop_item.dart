import "package:shop_aholic/app.dart";
import "package:shop_aholic/models/product.dart";

class ShopItem {
  String sid;
  int qty;
  Product item;
  bool done;

  ShopItem({this.sid = '', required this.item, this.qty = 1, this.done = false });

  Future<bool> save() async {
    int inserted = await App.db.insert('shopitems', {
      'sid': sid,
      'qty': qty,
      'status': done ? 1 : 0,
      'product_id': item.id,
    });
    return inserted == 1;
  }

  static Future<List<ShopItem>> readItems()  async {

    const sql = """SELECT s.sid AS sid, s.qty AS qty, s.status AS status,
      p.id AS product_id, p.name AS name, p.description AS description
    FROM
      shopitems s, products p
    WHERE
      s.product_id = p.id
    """;


    List<Map<String,Object?>> rows = await App.db.queryRaw(sql);
    return [
      for (final {
            'sid': sid as String,
            'qty': qty as int,
            'status': status as int,
            'product_id': pid as String,
            'name': pname as String,
            'description': pdesc as String
          } in rows)
        ShopItem(
          sid: sid,
          qty:qty,
          done: status == 1,
          item: Product(
            id: pid,
            name: pname,
            description: pdesc
          )
        )
    ];
  }
}