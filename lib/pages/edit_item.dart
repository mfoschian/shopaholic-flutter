import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_aholic/models/product.dart';
import 'package:gap/gap.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({super.key, required this.item, this.title});

  final Product item;
  final String? title;

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
        title: Text(widget.title ?? 'Modifica'),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              const MaxGap(20),
              TextFormField(
                initialValue: widget.item.name,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nome', border: OutlineInputBorder()),
                onSaved: (value) { _product!.name = value ?? ''; },
              ),
              const MaxGap(20),
              TextFormField(
                initialValue: widget.item.description,
                decoration: const InputDecoration(labelText: 'Descrizione', border: OutlineInputBorder()),
                onSaved: (value) { _product!.description = value; },
              ),
              const MaxGap(20),
              TypeAheadField<String>(
                controller: _controller,
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Negozio',
                    )
                  );
                },
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
      )
    );
    // return const Placeholder();
  }
}