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
}