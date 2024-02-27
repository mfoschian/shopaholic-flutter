import "package:shop_aholic/app.dart";

class Product {
  String? id;
  String name;
  String? description;
  String? shopName;

  Product({required this.id, required this.name, this.description, this.shopName});
  Product.fromJson(Map<String,dynamic> json) : 
    id = json['id'] as String?,
    name = json['name'] as String,
    description = json['description'] as String,
    shopName = json['shopName'] as String?
  ;

  Product dup() {
    return Product(id: id, name: name, description: description, shopName: shopName );
  }

  void updateFrom(Product p) {
    name = p.name;
    description = p.description;
    shopName = p.shopName;
  }

  Future<bool> save() async {
    int affected = 0;
    Map<String,Object?>? values = {
      'id': id ?? App.uuid(),
      'name': name,
      'description': description,
      'shopName': shopName
    };
    if( id == null ) {
      affected = await App.db.insert('products', values);
    }
    else {
      affected = await App.db.update('products', values, where: 'id=?', whereArgs: [id]);
      if( affected == 0 ) {
        // unkown id: insert !
        await App.db.insert('products', values); // return new id
        affected = 1;
      }
    }
    return affected == 1;
  }

  static Future<List<Product>> readItems()  async {
    List<Map<String,Object?>> rows = await App.db.query('products');
    return [
      for (final {
            'id': id as String,
            'name': name as String,
            'description': desc as String?,
            'shopName': sname as String?
          } in rows)
        Product(
          id: id,
          name: name,
          description: desc,
          shopName: sname
        )
    ];
  }

  static Future<List<String>> getShopNames() async {
    List<Map<String,Object?>> rows = await App.db.queryRaw("""
        SELECT DISTINCT shopName
        FROM products
        WHERE shopName IS NOT NULL
        ORDER BY shopName"""
    );
    return [
      for( final { 'shopName': name as String} in rows ) name
    ];
  }
}
