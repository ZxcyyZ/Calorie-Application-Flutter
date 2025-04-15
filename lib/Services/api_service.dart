import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firstflutterapp/Models/products_model.dart';

class ApiService {
  final http.Client _httpClient = http.Client();

  /// Fetch product information using a barcode
  Future<FoodAPI?> fetchProductInfo(String barcode) async {
    try {
      final url = Uri.parse('https://world.openfoodfacts.org/api/v2/product/${barcode}.json');
      print('Fetching product info from URL: $url'); // Debug line

      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        print('API response received for product info.'); // Debug line
        final productData = json.decode(response.body);
        if (productData['product'] != null) {
          print('Product data found in API response.'); // Debug line
          return FoodAPI.fromJson(productData['product']);
        } else {
          print('No product data found in API response.'); // Debug line
        }
      } else {
        print('Failed to fetch product info. Status code: ${response.statusCode}'); // Debug line
      }
    } catch (e) {
      print('Error fetching product info: $e'); // Debug line
    }
    return null;
  }

  /// Search products by name
  Future<List<FoodAPI>?> searchProductsByName(String productName) async {
    try {
      final url = Uri.parse(
          'https://world.openfoodfacts.org/cgi/search.pl?search_terms=${productName}&tagtype_0=countries&tag_contains_0=contains&tag_0=united%20kingdom&search_simple=1&json=1');
      print('Searching products by name from URL: $url'); // Debug line

      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        print('API response received for product search.'); // Debug line
        final searchResult = json.decode(response.body);
        if (searchResult['products'] != null) {
          print('Products found in API response.'); // Debug line
          return (searchResult['products'] as List)
              .map((product) => FoodAPI.fromJson(product))
              .toList();
        } else {
          print('No products found in API response.'); // Debug line
        }
      } else {
        print('Failed to search products. Status code: ${response.statusCode}'); // Debug line
      }
    } catch (e) {
      print('Error searching products: $e'); // Debug line
    }
    return null;
  }
}