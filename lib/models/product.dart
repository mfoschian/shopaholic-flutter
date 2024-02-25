import "package:shop_aholic/app.dart";
import "package:shop_aholic/models/shop_point.dart";

class Product {
  String? id;
  String name;
  String? description;
  ShopPoint? shopPoint;

  Product({required this.id, required this.name, this.description, this.shopPoint});

  Product dup() {
    return Product(id: id, name: name, description: description, shopPoint: shopPoint );
  }

  void updateFrom(Product p) {
    name = p.name;
    description = p.description;
    shopPoint = p.shopPoint;
  }

  Future<bool> save() async {
    int affected = 0;
    Map<String,Object?>? values = {
      'id': id ?? App.uuid(),
      'name': name,
      'description': description
    };
    if( id == null ) {
      affected = await App.db.insert('products', values);
    }
    else {
      affected = await App.db.update('products', values, where: 'id=?', whereArgs: [id]);
    }
    return affected == 1;
  }

  static Future<List<Product>> readItems()  async {
    List<Map<String,Object?>> rows = await App.db.query('products');
    return [
      for (final {
            'id': id as String,
            'name': name as String,
            'description': desc as String
          } in rows)
        Product(
          id: id,
          name: name,
          description: desc
        )
    ];
  }
}
