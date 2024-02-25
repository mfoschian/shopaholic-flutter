import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  List<String>? _shopNames;
  final TextEditingController _controller = TextEditingController();

  void loadData() async {
    _shopNames = await Product.getShopNames();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    _product ??= widget.item.dup();
    _controller.text = _product!.shopName ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton(onPressed: () {
            _formKey.currentState?.save(); // Trigger onSave on form fields
            _product!.shopName = _controller.text;
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
            const Text("Negozio"),
            TypeAheadField<String>(
              controller: _controller,
              suggestionsCallback: (String search) {
                if (search == '' || _shopNames == null) {
                  return const [];
                }
                List<String> res = _shopNames!.where((String option) {
                  return option.toLowerCase().contains(search.toLowerCase());
                }).toList();
                if(res.isEmpty && _shopNames!.length < 5) {
                  return _shopNames!.where((String s) => s.isNotEmpty).toList();
                }
                return res;
              },
              itemBuilder: (context, shopName) {
                return ListTile(
                  title: Text(shopName),
                  // subtitle: Text(city.country),
                );
              },
              emptyBuilder: (context) => const Text('Prova a scrivere il nome di un negozio'),
              onSelected: (String value) {
                _controller.text = value;
              },
            ),
          ]
        )
      )
    );
    // return const Placeholder();
  }
}