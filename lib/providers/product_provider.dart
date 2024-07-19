import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_product_list/main.dart';
import 'package:flutter_product_list/services/api_services.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();

  List<Product> _products = [];
  final List<Product> _favorites = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _skip = 0;
  Timer? _debounce;

  List<Product> get products => _products;
  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> init() async {
    debugPrint('Initializing ProductProvider...');
    await fetchProducts();
    await fetchFavorites();
    debugPrint('Initialization complete.');
  }

  Future<void> fetchProducts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();
    debugPrint('Fetching products...');

    try {
      final newProducts = await _apiService.fetchProducts(_skip);
      debugPrint('Fetched ${newProducts.length} new products.');

      if (newProducts.isEmpty) {
        _hasMore = false;
        debugPrint('No more products to fetch.');
      } else {
        _products.addAll(newProducts);
        _skip += newProducts.length;
      }
    } catch (e) {
      _hasMore = false;
      debugPrint('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFavorites() async {
    debugPrint('Fetching favorites...');
    try {
      final favoriteIds = await _databaseService.getFavoriteIds();
      debugPrint('Favorite IDs: $favoriteIds');

      _favorites.clear();
      for (var id in favoriteIds) {
        final product = await _apiService.fetchProductById(id);
        _favorites.add(product);
      }
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
    }
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    debugPrint('Refreshing products...');
    _skip = 0;
    _hasMore = true;
    _products.clear();
    await fetchProducts();
  }

  Future<void> searchProducts(String query) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();
    debugPrint('Searching products with query: $query');

    try {
      final results = await _apiService.searchProducts(query);
      if (results.isEmpty) {
        _showEmptyResultDialog();
      }
      _products = results;
      debugPrint('Search results: ${results.length} products found.');
    } catch (error) {
      _products = [];
      debugPrint('Error searching products: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchProductsWithDebounce(String query) {
    debugPrint('Debouncing search query: $query');
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchProducts(query);
    });
  }

  void handleScroll(ScrollController scrollController) {
    debugPrint('Handling scroll...');
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        debugPrint('End of scroll reached. Fetching more products...');
        fetchProducts();
      }
    });
  }

  Future<void> toggleFavorite(Product product) async {
    final isFav = _favorites.any((p) => p.id == product.id);
    debugPrint(
        'Toggling favorite for product id: ${product.id}. Currently isFav: $isFav');

    try {
      if (isFav) {
        await _databaseService.removeFavorite(product.id);
        _favorites.removeWhere((p) => p.id == product.id);
        debugPrint('Removed from favorites');
      } else {
        await _databaseService.addFavorite(product.id);
        _favorites.add(product);
        debugPrint('Added to favorites');
      }
      await fetchFavorites(); // Refresh the favorites list from the database
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favorites.any((item) => item.id == product.id);
  }

  void _showEmptyResultDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('No Results'),
              content: const Text('No products found matching your search.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    refreshProducts();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    });
  }
}
