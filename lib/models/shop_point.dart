class ShopPoint {
  String id;
  String name;

  ShopPoint({required this.id, required this.name});

  static Future<List<ShopPoint>> readItems()  async {
    return [
      ShopPoint(id: '1', name: 'A&O'),
      ShopPoint(id: '2', name: 'Siciliano'),
      ShopPoint(id: '3', name: 'Regolin'),
      ShopPoint(id: '4', name: 'Bosio'),
    ];
  }

}