import "package:shop_aholic/app.dart";
import "package:shop_aholic/models/product.dart";

class ShopItem {
  String? sid;
  int qty;
  Product product;
  bool done;

  ShopItem({this.sid, required this.product, this.qty = 1, this.done = false });

  static Future<bool> saveFromJson(Map<String,dynamic> json) async {
    await App.db.insert('shopitems', {
      'sid': json["sid"],
      'qty': json["qty"],
      'status': json["status"],
      'product_id': json["item_id"]
    });

    return true;
  }

  Future<bool> save() async {
    int affected = 0;
    if( sid == null) {
      sid = App.uuid();
      affected = await App.db.insert('shopitems', {
        'sid': sid,
        'qty': qty,
        'status': done ? 1 : 0,
        'product_id': product.id,
      });
    }
    else {
      // Update
      affected = await App.db.update('shopitems', {
        'qty': qty,
        'status': done ? 1 : 0,
      }, where: 'sid=?', whereArgs: [sid]);
    }
    return affected == 1;
  }

  Future<bool> del() async {
    int deleted = await App.db.delete('shopitems', where: 'sid = ?', whereArgs: [sid]);
    return deleted == 1;
  }

  static Future<List<ShopItem>> readItems()  async {

    const sql = """SELECT s.sid AS sid, s.qty AS qty, s.status AS status,
      p.id AS product_id, p.name AS name, p.description AS description, p.shopName as shopName
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
            'description': pdesc as String?,
            'shopName': sname as String?
          } in rows)
        ShopItem(
          sid: sid,
          qty:qty,
          done: status == 1,
          product: Product(
            id: pid,
            name: pname,
            description: pdesc,
            shopName: sname
          )
        )
    ];
  }
}