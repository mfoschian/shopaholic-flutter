import "package:shop_aholic/models/shop_point.dart";

class KnownItem {
  String id;
  String name;
  String? description;
  ShopPoint? shopPoint;

  KnownItem({required this.id, required this.name, this.description, this.shopPoint});

  static Future<List<KnownItem>> readItems()  async {
    return [
      KnownItem(id: '1', name: 'Primo'),
      KnownItem(id: '2', name: 'Secondo'),
      KnownItem(id: '3', name: 'Terzo'),
      KnownItem(id: '4', name: 'Quarto'),
      KnownItem(id: '5', name: 'Quinto'),
      KnownItem(id: '6', name: 'Sesto'),
      KnownItem(id: '7', name: 'Settimo'),
    ];
  }
}
