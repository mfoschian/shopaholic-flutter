import "package:shop_aholic/models/shop_point.dart";

class Product {
  String id;
  String name;
  String? description;
  ShopPoint? shopPoint;

  Product({required this.id, required this.name, this.description, this.shopPoint});

  static Future<List<Product>> readItems()  async {
    return [
      Product(id: '1', name: 'Primo'),
      Product(id: '2', name: 'Secondo'),
      Product(id: '3', name: 'Terzo'),
      Product(id: '4', name: 'Quarto'),
      Product(id: '5', name: 'Quinto'),
      Product(id: '6', name: 'Sesto'),
      Product(id: '7', name: 'Settimo'),
    ];
  }
}
