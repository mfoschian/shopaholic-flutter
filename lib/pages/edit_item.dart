import 'package:flutter/material.dart';
import 'package:shop_aholic/models/product.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({super.key, required this.item});

  final Product item;
  final String title = 'Modifica';

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {

  final _formKey = GlobalKey<FormState>();
  Product? _product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton(onPressed: () {
            _product = widget.item.dup();
            _formKey.currentState?.save();
            Navigator.pop(context, _product);
          },
          child: const Icon(Icons.save)
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const Text("Nome"),
            TextFormField(
              initialValue: widget.item.name,
              onSaved: (value) { _product!.name = value ?? ''; },
            ),
            const Text("Descrizione"),
            TextFormField(
              initialValue: widget.item.description,
              onSaved: (value) { _product!.description = value; },
            ),
          ]
        )
      )
    );
    // return const Placeholder();
  }
}