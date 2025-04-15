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

  @JsonKey(name: 'image_nutrition_url')
  String? imageNutritionUrl;

  @JsonKey(name: 'image_url')
  String? imageUrl;

  FoodAPI({
    this.productName,
    this.nutriments,
    this.imageNutritionUrl,
    this.imageUrl,
  });

  factory FoodAPI.fromJson(Map<String, dynamic> json) => _$FoodAPIFromJson(json);

  Map<String, dynamic> toJson() => _$FoodAPIToJson(this);
}

@JsonSerializable()
class Nutriments {
  @JsonKey(name: 'salt')
  double? salt;

  @JsonKey(name: 'fat')
  double? fat;

  @JsonKey(name: 'saturated-fat')
  double? saturatedFat;

  @JsonKey(name: 'sugars')
  double? sugars;

  @JsonKey(name: 'energy-kcal')
  double? energy;

  @JsonKey(name: 'energy-kcal_serving')
  double? energyServe;

  @JsonKey(name: 'proteins_100g')
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