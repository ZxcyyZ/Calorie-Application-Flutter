// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => FoodAPI.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{'products': instance.products};

ProductData _$ProductDataFromJson(Map<String, dynamic> json) => ProductData(
  product:
      json['product'] == null
          ? null
          : FoodAPI.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{'product': instance.product};

FoodAPI _$FoodAPIFromJson(Map<String, dynamic> json) => FoodAPI(
  productName: json['product_name'] as String?,
  nutriments:
      json['nutriments'] == null
          ? null
          : Nutriments.fromJson(json['nutriments'] as Map<String, dynamic>),
  categories: _categoriesFromJson(json['categories']),
  imageNutritionUrl: json['image_nutrition_url'] as String?,
  imageUrl: json['image_url'] as String?,
);

Map<String, dynamic> _$FoodAPIToJson(FoodAPI instance) => <String, dynamic>{
  'product_name': instance.productName,
  'nutriments': instance.nutriments,
  'categories': _categoriesToJson(instance.categories),
  'image_nutrition_url': instance.imageNutritionUrl,
  'image_url': instance.imageUrl,
};

Nutriments _$NutrimentsFromJson(Map<String, dynamic> json) => Nutriments(
  salt: _parseDouble(json['salt']),
  fat: _parseDouble(json['fat']),
  saturatedFat: _parseDouble(json['saturated-fat']),
  sugars: _parseDouble(json['sugars']),
  energy: _parseDouble(json['energy-kcal']),
  energyServe: _parseDouble(json['energy-kcal_serving']),
  proteinsServe: _parseDouble(json['proteins_100g']),
);

Map<String, dynamic> _$NutrimentsToJson(Nutriments instance) =>
    <String, dynamic>{
      'salt': instance.salt,
      'fat': instance.fat,
      'saturated-fat': instance.saturatedFat,
      'sugars': instance.sugars,
      'energy-kcal': instance.energy,
      'energy-kcal_serving': instance.energyServe,
      'proteins_100g': instance.proteinsServe,
    };
