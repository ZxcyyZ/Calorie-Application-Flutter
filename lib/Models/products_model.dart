import 'package:json_annotation/json_annotation.dart';
part 'products_model.g.dart'; // Required for code generation

@JsonSerializable()
class SearchResult {
  @JsonKey(name: 'products')
  List<FoodAPI>? products;

  SearchResult({this.products});

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}

@JsonSerializable()
class ProductData {
  @JsonKey(name: 'product')
  FoodAPI? product;

  ProductData({this.product});

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}

@JsonSerializable()
class FoodAPI {
  @JsonKey(name: 'product_name')
  String? productName;

  @JsonKey(name: 'nutriments')
  Nutriments? nutriments;

  @JsonKey(name: 'categories', fromJson: _categoriesFromJson, toJson: _categoriesToJson)
  List<String>? categories;

  @JsonKey(name: 'image_nutrition_url')
  String? imageNutritionUrl;

  @JsonKey(name: 'image_url')
  String? imageUrl;

  FoodAPI({
    this.productName,
    this.nutriments,
    this.categories,
    this.imageNutritionUrl,
    this.imageUrl,
  });

  factory FoodAPI.fromJson(Map<String, dynamic> json) => _$FoodAPIFromJson(json);

  Map<String, dynamic> toJson() => _$FoodAPIToJson(this);
}

// Helper functions to handle the conversion of categories
List<String> _categoriesFromJson(dynamic categories) {
  if (categories == null || categories is! String || categories.isEmpty) {
    return [];
  }
  return categories.split(',').map((category) => category.trim()).toList();
}

String? _categoriesToJson(List<String>? categories) {
  if (categories == null || categories.isEmpty) {
    return null;
  }
  return categories.join(',');
}

@JsonSerializable()
class Nutriments {
  @JsonKey(name: 'salt', fromJson: _parseDouble)
  double? salt;

  @JsonKey(name: 'fat', fromJson: _parseDouble)
  double? fat;

  @JsonKey(name: 'saturated-fat', fromJson: _parseDouble)
  double? saturatedFat;

  @JsonKey(name: 'sugars', fromJson: _parseDouble)
  double? sugars;

  @JsonKey(name: 'energy-kcal', fromJson: _parseDouble)
  double? energy;

  @JsonKey(name: 'energy-kcal_serving', fromJson: _parseDouble)
  double? energyServe;

  @JsonKey(name: 'proteins_100g', fromJson: _parseDouble)
  double? proteinsServe;

  Nutriments({
    this.salt,
    this.fat,
    this.saturatedFat,
    this.sugars,
    this.energy,
    this.energyServe,
    this.proteinsServe,
  });

  factory Nutriments.fromJson(Map<String, dynamic> json) =>
      _$NutrimentsFromJson(json);

  Map<String, dynamic> toJson() => _$NutrimentsToJson(this);
}

// Helper function to safely parse numeric fields
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}