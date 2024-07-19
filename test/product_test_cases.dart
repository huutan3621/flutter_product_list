import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_product_list/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('ApiService', () {
    test('fetchProducts returns a list of products', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'products': [
              {'id': 1, 'title': 'Product 1'},
              {'id': 2, 'title': 'Product 2'},
            ],
          }),
          200,
        );
      });
      final apiService = ApiService(client: mockClient);

      final products = await apiService.fetchProducts(0);
      expect(products.length, 2);
      expect(products[0].id, 1);
      expect(products[0].title, 'Product 1');
    });

    test('fetchProductById returns a product', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'id': 1, 'title': 'Product 1'}),
          200,
        );
      });
      final apiService = ApiService(client: mockClient);

      final product = await apiService.fetchProductById(1);
      expect(product.id, 1);
      expect(product.title, 'Product 1');
    });

    test('searchProducts returns a list of products', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'products': [
              {'id': 1, 'title': 'Product 1'},
            ],
          }),
          200,
        );
      });
      final apiService = ApiService(client: mockClient);

      final products = await apiService.searchProducts('query');
      expect(products.length, 1);
      expect(products[0].id, 1);
      expect(products[0].title, 'Product 1');
    });
  });
}
