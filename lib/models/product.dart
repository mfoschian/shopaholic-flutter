import "package:shop_aholic/app.dart";
import "package:shop_aholic/models/shop_point.dart";

class Product {
  String id;
  String name;
  String? description;
  ShopPoint? shopPoint;

  Product({required this.id, required this.name, this.description, this.shopPoint});

  Future<bool> save() async {
    int inserted = await App.db.insert('products', {
      'id': id,
      'name': name,
      'description': description
    });
    return inserted == 1;
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
