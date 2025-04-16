import 'package:flutter/material.dart';
import 'package:firstflutterapp/Services/api_service.dart';
import 'package:firstflutterapp/Models/products_model.dart';

class ProductApiProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  String _searchQuery = '';
  String _barcode = '';
  FoodAPI? _product;
  List<FoodAPI> _products = [];
  bool _isBusy = false;

  // Getters
  String get searchQuery => _searchQuery;
  String get barcode => _barcode;
  FoodAPI? get product => _product;
  List<FoodAPI> get products => _products;
  bool get isBusy => _isBusy;

  // Setters
  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  set barcode(String value) {
    _barcode = value;
    notifyListeners();
  }

  set product(FoodAPI? value) {
    _product = value;
    notifyListeners();
  }

  set products(List<FoodAPI> value) {
    _products = value;
    notifyListeners();
  }

  set isBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  /// Fetch product information using a barcode
  Future<void> fetchProductInfo() async {
    if (_barcode.isEmpty) return;

    isBusy = true;
    try {
      final fetchedProduct = await _apiService.fetchProductInfo(_barcode);
      if (fetchedProduct != null) {
        product = fetchedProduct;
      }
    } finally {
      isBusy = false;
    }
  }

  /// Search products by name
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) return;

    isBusy = true;
    try {
      searchQuery = query;
      final searchResult = await _apiService.searchProductsByName(query);
      if (searchResult != null) {
        products = searchResult;
      }
    } finally {
      isBusy = false;
    }
  }

  /// Clear the product list
  void clearProducts() {
    products = [];
  }

  /// Get the top 8 products
  List<FoodAPI> get topProducts => products.take(8).toList();

  /// Filter products by name and category
  Future<void> filterProductsByInfo(String query, String category) async {
    if (query.isEmpty || category.isEmpty) return;

    isBusy = true;
    try {
      debugPrint('Filtering products with query: $query and category: $category');
      final filteredProducts = await _apiService.filterProductsByInfo(query, category);
      if (filteredProducts != null) {
        products = filteredProducts;
        debugPrint('Filtered products found: ${filteredProducts.length}');
      } else {
        debugPrint('No filtered products found.');
      }
    } catch (e) {
      debugPrint('Error filtering products: $e');
    } finally {
      isBusy = false;
    }
  }

  FoodAPI? findBetterAlternative(FoodAPI selectedProduct) {
  if (products.isEmpty) {
    debugPrint('No products available to compare.');
    return null;
  }

  double selectedCalories = selectedProduct.nutriments?.energy ?? double.infinity;

  // Sort products by calories in ascending order
  products.sort((a, b) {
    double aCalories = a.nutriments?.energy ?? double.infinity;
    double bCalories = b.nutriments?.energy ?? double.infinity;
    return aCalories.compareTo(bCalories);
  });

  for (var product in products) {
    // Skip the selected product itself
    if (product.productName == selectedProduct.productName) continue;

    double productCalories = product.nutriments?.energy ?? double.infinity;

    // Check if the product has lower calories
    if (productCalories < selectedCalories) {
      // Check if at least one other property is lower
      if ((product.nutriments?.salt ?? double.infinity) < (selectedProduct.nutriments?.salt ?? double.infinity) ||
          (product.nutriments?.sugars ?? double.infinity) < (selectedProduct.nutriments?.sugars ?? double.infinity) ||
          (product.nutriments?.proteinsServe ?? double.infinity) < (selectedProduct.nutriments?.proteinsServe ?? double.infinity) ||
          (product.nutriments?.fat ?? double.infinity) < (selectedProduct.nutriments?.fat ?? double.infinity) ||
          (product.nutriments?.saturatedFat ?? double.infinity) < (selectedProduct.nutriments?.saturatedFat ?? double.infinity)) {
        debugPrint('Better alternative found: ${product.productName}');
        return product; // Return immediately if a better alternative is found
      }
    }
  }

  debugPrint('No better alternative found.');
  return null;
}
}