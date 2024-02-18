class ShopItem {
  String name;

  ShopItem({required this.name});

  static List<ShopItem> getItems() {
    List<ShopItem> items = [];

    for( int i=0; i<10; i++ ) {
      items.add(ShopItem(name: 'Articolo $i'));
    }

    return items;
  }
}