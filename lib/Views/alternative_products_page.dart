import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstflutterapp/Provider/product_api_provider.dart';
import 'package:firstflutterapp/Models/products_model.dart';

class AlternativeProductsPage extends StatefulWidget {
  final String productName;
  final String category;
  final double? energy;
  final double? energyServe;
  final double? salt;
  final double? sugars;
  final double? proteinsServe;
  final double? fat;
  final double? saturatedFat;
  final String? imageUrl; // Added imageUrl parameter

  const AlternativeProductsPage({
    super.key,
    required this.productName,
    required this.category,
    this.energy,
    this.energyServe,
    this.salt,
    this.sugars,
    this.proteinsServe,
    this.fat,
    this.saturatedFat,
    this.imageUrl
  });

  @override
  State<AlternativeProductsPage> createState() => _AlternativeProductsPageState();
}

class _AlternativeProductsPageState extends State<AlternativeProductsPage> {
  bool _hasFiltered = false; // Flag to ensure filtering runs only once
  FoodAPI? betterAlternative; // Store the better alternative product

  Future<void> _filterProducts(BuildContext context) async {
    final productProvider = Provider.of<ProductApiProvider>(context, listen: false);
    debugPrint('Filtering products for: ${widget.productName} in category: ${widget.category}');
    await productProvider.filterProductsByInfo(widget.productName, widget.category);

    // Find a better alternative after filtering
    final selectedProduct = FoodAPI(
      productName: widget.productName,
      nutriments: Nutriments(
        energy: widget.energy,
        energyServe: widget.energyServe,
        salt: widget.salt,
        sugars: widget.sugars,
        proteinsServe: widget.proteinsServe,
        fat: widget.fat,
        saturatedFat: widget.saturatedFat,
      ),
    );
    setState(() {
      betterAlternative = productProvider.findBetterAlternative(selectedProduct);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductApiProvider(),
      builder: (context, child) {
        if (!_hasFiltered) {
          // Run filtering only once
          _hasFiltered = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _filterProducts(context);
          });
        }

        final productProvider = Provider.of<ProductApiProvider>(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text(
              'Alternative Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: Consumer<ProductApiProvider>(
            builder: (context, provider, child) {
              if (provider.isBusy) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (provider.products.isEmpty) {
                return const Center(
                  child: Text(
                    'No alternative products found.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selected Product Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      child: Text(
                        'Selected Product',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: 370, // Adjusted height to fit all nutritional information and button
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.productName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Category: ${widget.category}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Display all nutritional information
                                _buildNutritionalInfoRow(
                                  'Calories (kCal)',
                                  widget.energy,
                                  betterAlternative?.nutriments?.energy,
                                ),
                                _buildNutritionalInfoRow(
                                  'Calories Per Serving (kCal)',
                                  widget.energyServe,
                                  betterAlternative?.nutriments?.energyServe,
                                ),
                                _buildNutritionalInfoRow(
                                  'Salt (g)',
                                  widget.salt,
                                  betterAlternative?.nutriments?.salt,
                                ),
                                _buildNutritionalInfoRow(
                                  'Sugars (g)',
                                  widget.sugars,
                                  betterAlternative?.nutriments?.sugars,
                                ),
                                _buildNutritionalInfoRow(
                                  'Protein per 100g (g)',
                                  widget.proteinsServe,
                                  betterAlternative?.nutriments?.proteinsServe,
                                ),
                                _buildNutritionalInfoRow(
                                  'Fat (g)',
                                  widget.fat,
                                  betterAlternative?.nutriments?.fat,
                                ),
                                _buildNutritionalInfoRow(
                                  'Saturated Fat (g)',
                                  widget.saturatedFat,
                                  betterAlternative?.nutriments?.saturatedFat,
                                ),
                                const SizedBox(height: 10),

                                // View Image Button
                                ElevatedButton(
                                  onPressed: () {
                                    // Show product image in an alert dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(widget.productName),
                                          content: widget.imageUrl != null
                                              ? Image.network(widget.imageUrl!)
                                              : const Text('No image available'), // Replace with actual image logic
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: const Text(
                                    'View Image',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Better Alternative Section
                    if (betterAlternative != null) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                        child: Text(
                          'Better Alternative',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            height: 340, // Adjusted height to fit all nutritional information and button
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    betterAlternative!.productName ?? 'Product Name',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Display all nutritional information
                                  _buildNutritionalInfoRow(
                                    'Calories (kCal)',
                                    betterAlternative!.nutriments?.energy,
                                    widget.energy,
                                  ),
                                  _buildNutritionalInfoRow(
                                    'Calories Per Serving (kCal)',
                                    betterAlternative!.nutriments?.energyServe,
                                    widget.energyServe,
                                  ),
                                  _buildNutritionalInfoRow(
                                    'Salt (g)',
                                    betterAlternative!.nutriments?.salt,
                                    widget.salt,
                                  ),
                                  _buildNutritionalInfoRow(
                                    'Sugars (g)',
                                    betterAlternative!.nutriments?.sugars,
                                    widget.sugars,
                                  ),
                                  _buildNutritionalInfoRow(
                                    'Protein per 100g (g)',
                                    betterAlternative!.nutriments?.proteinsServe,
                                    widget.proteinsServe,
                                  ),
                                  _buildNutritionalInfoRow(
                                    'Fat (g)',
                                    betterAlternative!.nutriments?.fat,
                                    widget.fat,
                                  ),
                                  _buildNutritionalInfoRow(
                                    'Saturated Fat (g)',
                                    betterAlternative!.nutriments?.saturatedFat,
                                    widget.saturatedFat,
                                  ),
                                  const SizedBox(height: 10),

                                  // View Image Button
                                  ElevatedButton(
                                    onPressed: () {
                                      // Show better alternative image in an alert dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(betterAlternative!.productName ?? 'Product Image'),
                                            content: betterAlternative!.imageUrl != null
                                                ? Image.network(betterAlternative!.imageUrl!)
                                                : const Text('No image available'), // Replace with actual image logic
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                child: const Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: const Text(
                                      'View Image',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNutritionalInfoRow(String label, double? selectedValue, double? betterValue) {
    // Determine the text color based on comparison
    Color textColor;
    if (selectedValue == null || betterValue == null) {
      textColor = Colors.grey; // Default color if values are null
    } else if (selectedValue > betterValue) {
      textColor = Colors.red; // Red if selected product has a higher value
    } else if (selectedValue < betterValue) {
      textColor = Colors.green; // Green if selected product has a lower value
    } else {
      textColor = Colors.black; // Black if values are equal
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Text(
            selectedValue?.toStringAsFixed(2) ?? 'N/A',
            style: TextStyle(
              fontSize: 14,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}