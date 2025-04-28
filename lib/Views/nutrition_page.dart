import 'package:firstflutterapp/Views/alternative_products_page.dart';
import 'package:firstflutterapp/Views/barcode_page.dart';
import 'package:firstflutterapp/Views/main_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstflutterapp/Provider/product_api_provider.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductApiProvider(),
      builder: (context, child) {
        final productProvider = Provider.of<ProductApiProvider>(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  'Nutrition Search',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instruction Text
                  const Text(
                    'Search products through the search bar below, to gather nutritional information about them.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search Bar Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Product Search',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onSubmitted: (value) async {
                        debugPrint('Search Query: $value');
                        // Trigger search in the ProductApiProvider
                        if (value.isNotEmpty) {
                          await productProvider.searchProducts(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Product List Section
                  Consumer<ProductApiProvider>(
                    builder: (context, provider, child) {
                      if (provider.isBusy) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (provider.products.isEmpty) {
                        return const Center(
                          child: Text(
                            'No products found. Try searching for something else.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.products.length,
                        itemBuilder: (context, index) {
                          final product = provider.products[index];
                          debugPrint('Search Results: ${product.productName}');
                          debugPrint('Categories: ${product.categories}');

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: SizedBox(
                                height: 370, // Adjusted height to fit all nutritional information
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Product Name
                                      Text(
                                        product.productName ?? 'Product Name',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black, // Black text color
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // Category
                                      Text(
                                        'Category: ${product.categories?.last ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black, // Black text color
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // Nutritional Information
                                      _buildNutritionalInfoRow(
                                        'Calories (kCal)',
                                        product.nutriments?.energy,
                                      ),
                                      _buildNutritionalInfoRow(
                                        'Calories Per Serving (kCal)',
                                        product.nutriments?.energyServe,
                                      ),
                                      _buildNutritionalInfoRow(
                                        'Salt (g)',
                                        product.nutriments?.salt,
                                      ),
                                      _buildNutritionalInfoRow(
                                        'Sugars (g)',
                                        product.nutriments?.sugars,
                                      ),
                                      _buildNutritionalInfoRow(
                                        'Protein per 100g (g)',
                                        product.nutriments?.proteinsServe,
                                      ),
                                      _buildNutritionalInfoRow(
                                        'Fat (g)',
                                        product.nutriments?.fat,
                                      ),
                                      _buildNutritionalInfoRow(
                                        'Saturated Fat (g)',
                                        product.nutriments?.saturatedFat,
                                      ),
                                      const SizedBox(height: 10),

                                      // Buttons Section
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Find Alternative Button
                                          ElevatedButton(
                                            onPressed: () async {
                                              debugPrint('Finding alternatives for: ${product.productName}');
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AlternativeProductsPage(
                                                    productName: product.productName ?? '',
                                                    category: product.categories?.last ?? '',
                                                    energy: product.nutriments?.energy ?? 0,
                                                    energyServe: product.nutriments?.energyServe ?? 0,
                                                    salt: product.nutriments?.salt ?? 0,
                                                    sugars: product.nutriments?.sugars ?? 0,
                                                    proteinsServe: product.nutriments?.proteinsServe ?? 0,
                                                    fat: product.nutriments?.fat ?? 0,
                                                    saturatedFat: product.nutriments?.saturatedFat ?? 0,
                                                    imageUrl: product.imageUrl ?? '',
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                            child: const Text(
                                              'Find Alternative',
                                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ),

                                          const SizedBox(width: 10), // Add spacing between buttons

                                          // View Image Button
                                          ElevatedButton(
                                            onPressed: () {
                                              // Show product image in an alert dialog
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(product.productName ?? 'Product Image'),
                                                    content: product.imageUrl != null
                                                        ? Image.network(
                                                            product.imageUrl!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : const Text('No image available'),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home Button
                IconButton(
                  icon: const Icon(Icons.home, size: 40),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                ),
                // Barcode Scanner Button
                SizedBox(
                  width: 100, // Adjust the width
                  height: 100, // Adjust the height
                  child: FloatingActionButton(
                    onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BarcodePage()),
                      );
                    },
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.qr_code_scanner, size: 40, color: Colors.white),
                  ),
                ),
                // Settings Button
                IconButton(
                  icon: const Icon(Icons.settings, size: 40),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionalInfoRow(String label, double? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black, // Black text color
            ),
          ),
          Text(
            value?.toStringAsFixed(2) ?? 'N/A',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black, // Black text color
            ),
          ),
        ],
      ),
    );
  }
}