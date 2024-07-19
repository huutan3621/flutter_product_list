import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ApiService {
  final String baseUrl;
  final http.Client client;

  ApiService({this.baseUrl = 'https://dummyjson.com', http.Client? client})
      : client = client ?? http.Client();

  Future<List<Product>> fetchProducts(int skip) async {
    try {
      final response =
          await client.get(Uri.parse('$baseUrl/products?limit=20&skip=$skip'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final products = (data['products'] as List)
            .map((product) => Product.fromJson(product))
            .toList();
        return products;
      } else {
        throw Exception(
            'Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response =
          await client.get(Uri.parse('$baseUrl/products/search?q=$query'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final products = (data['products'] as List)
            .map((product) => Product.fromJson(product))
            .toList();
        return products;
      } else {
        throw Exception(
            'Failed to search products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error searching products: $e');
      rethrow;
    }
  }

  Future<Product> fetchProductById(int id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/products/$id'));
      if (response.statusCode == 200) {
        final product = json.decode(response.body);
        return Product.fromJson(product);
      } else {
        throw Exception(
            'Failed to load product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching product by ID: $e');
      rethrow;
    }
  }
}
