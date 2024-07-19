import 'package:flutter/material.dart';
import 'package:flutter_product_list/screens/product_list_item.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Products'),
      ),
      body: productProvider.favorites.isEmpty
          ? const Center(child: Text('No favorite products yet.'))
          : ListView.builder(
              itemCount: productProvider.favorites.length,
              itemBuilder: (context, index) {
                final product = productProvider.favorites[index];
                return ProductListItem(product: product);
              },
            ),
    );
  }
}
