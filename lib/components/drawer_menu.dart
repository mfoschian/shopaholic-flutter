import 'package:flutter/material.dart';

class MyDrawerMenu extends StatelessWidget {
  const MyDrawerMenu({super.key, this.onImport, this.onExport });

  final Function? onImport;
  final Function? onExport;

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
            leading: const Icon(Icons.upload),
            title: const Text('Importa'),
            onTap: () {
              if(onImport != null ) {
                onImport!();
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Esporta'),
            onTap: () {
              if(onExport != null ) {
                onExport!();
              }
              Navigator.pop(context);
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