import 'package:flutter/material.dart';

class MyDrawerMenu extends StatelessWidget {
  const MyDrawerMenu({super.key, this.onImport, this.onExport, this.onNewShopping });

  final Function? onImport;
  final Function? onExport;
  final Function? onNewShopping;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          GestureDetector(
            child: const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'ShopAholic',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              )
            ),
            onTap: () { Navigator.pop(context); }
          ),
          ListTile(
            leading: const Icon(Icons.new_releases),
            title: const Text('Nuova Spesa'),
            onTap: () {
              if(onNewShopping != null ) {
                onNewShopping!().then( (ok) {
                  Navigator.pop(context);
                });
              }
              else {
                Navigator.pop(context);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text('Importa'),
            onTap: () {
              Navigator.pop(context);
              if(onImport != null ) {
                onImport!();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Esporta'),
            onTap: () {
              Navigator.pop(context);
              if(onExport != null ) {
                onExport!();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
        ],
      )
    );
  }
}