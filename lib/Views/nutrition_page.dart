import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstflutterapp/Provider/product_api_provider.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Provider<ProductApiProvider>(
      create: (_) => ProductApiProvider(),
      builder: (context, child){
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
                  onSubmitted: (value) async{
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  debugPrint('Search Results${product.productName}');
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
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
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Nutritional Information
                          Text(
                            'Total Calories (kCal): ${product.nutriments?.energy ?? 'N/A'}\n'
                            'Calories Per Serving (kCal): ${product.nutriments?.energyServe ?? 'N/A'}\n'
                            'Salt (g): ${product.nutriments?.salt ?? 'N/A'}\n'
                            'Sugars (g): ${product.nutriments?.sugars ?? 'N/A'}\n'
                            'Protein per 100g (g): ${product.nutriments?.proteinsServe ?? 'N/A'}\n'
                            'Fat (g): ${product.nutriments?.fat ?? 'N/A'}\n'
                            'Saturated Fat (g): ${product.nutriments?.saturatedFat ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                Navigator.pop(context); // Navigate back to the home page
              },
            ),
            // Barcode Scanner Button
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, size: 40),
              color: Colors.orange,
              onPressed: () {
                Navigator.pushNamed(context, '/barcodePage'); // Navigate to barcode scanner page
              },
            ),
            // Settings Button
            IconButton(
              icon: const Icon(Icons.settings, size: 40),
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/settingsPage'); // Navigate to settings page
              },
            ),
          ],
        ),
      ),
    );
      },
    );
  }
}