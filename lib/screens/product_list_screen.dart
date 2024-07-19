import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'saved_items_screen.dart';
import 'product_list_item.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProducts();
    });

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.handleScroll(_scrollController);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeProducts() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.init();
  }

  void _onSearchChanged(String query) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.searchProductsWithDebounce(query);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: _buildAppBarActions(productProvider),
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(child: _buildProductList(productProvider)),
          if (productProvider.isLoading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions(ProductProvider productProvider) {
    return [
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          productProvider.refreshProducts();
        },
      ),
      IconButton(
        icon: const Icon(Icons.favorite),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SavedItemsScreen()),
          );
        },
      ),
    ];
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          labelText: 'Search Products',
          border: OutlineInputBorder(),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildProductList(ProductProvider productProvider) {
    return productProvider.isLoading && productProvider.products.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return ProductListItem(product: product);
            },
          );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
