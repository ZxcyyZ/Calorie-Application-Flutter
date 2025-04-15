import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firstflutterapp/Models/products_model.dart';

class ApiService {
  final http.Client _httpClient = http.Client();

  /// Fetch product information using a barcode
  Future<FoodAPI?> fetchProductInfo(String barcode) async {
    try {
      final url = Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcode.json');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final productData = json.decode(response.body);
        if (productData['product'] != null) {
          return FoodAPI.fromJson(productData['product']);
        }
      }
    } catch (e) {
      print('Error fetching product info: $e');
    }
    return null;
  }

  /// Search products by name
  Future<List<FoodAPI>?> searchProductsByName(String productName) async {
    try {
      final url = Uri.parse(
          'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$productName&tagtype_0=countries&tag_contains_0=contains&tag_0=united%20kingdom&search_simple=1&json=1');
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final searchResult = json.decode(response.body);
        if (searchResult['products'] != null) {
          return (searchResult['products'] as List)
              .map((product) => FoodAPI.fromJson(product))
              .toList();
        }
      }
    } catch (e) {
      print('Error searching products: $e');
    }
    return null;
  }
}