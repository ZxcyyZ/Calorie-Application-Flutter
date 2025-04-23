import 'package:firstflutterapp/Models/database_model.dart';
import 'package:firstflutterapp/Views/barcode_page.dart';
import 'package:firstflutterapp/Views/main_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:firstflutterapp/Views/calorie_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstflutterapp/Provider/product_api_provider.dart';
import 'package:firstflutterapp/Provider/calorie_count_provider.dart'; 
import 'package:firstflutterapp/Services/database_service.dart'; 
import 'package:intl/intl.dart';

class SetCaloriesPage extends StatelessWidget {
  const SetCaloriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalorieCountProvider()),
        ChangeNotifierProvider(create: (_) => ProductApiProvider()),
      ],
      builder: (context, child) {
        final productProvider = Provider.of<ProductApiProvider>(context);
        final calorieCountProvider = Provider.of<CalorieCountProvider>(context, listen: false);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text(
              'Calorie Add',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                    'Search for products below to add to your daily calorie intake.',
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
                        hintText: 'Search for a product',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onSubmitted: (value) async {
                        debugPrint('Search Query: $value');
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
                                        color: Colors.black,
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
                                        // Add Calories Button
                                        ElevatedButton(
                                          onPressed: () {
                                            addCalories(context, product, calorieCountProvider);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => const CaloriePage()),
                                            );},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue, // Changed to blue
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          child: const Text(
                                            'Add Calories',
                                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ),

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
            SizedBox(
              width: 150,
              height: 100,
              child: IconButton(
              icon: const Icon(Icons.home, size: 40),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
            ),
            ),
            SizedBox(
              width: 100, // Adjust the width
              height: 100, // Adjust the height
              child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BarcodePage()),
                );
            // Navigate to Barcode Page
          },
          backgroundColor: Colors.orange,
          child: const Icon(Icons.qr_code_scanner, size: 40, color: Colors.white),
           // Adjust icon size
        ),
      ),
            SizedBox(
        width: 150, // Adjust the width
        height: 100, // Adjust the height
        child: IconButton(
          icon: const Icon(Icons.settings, size: 40), // Adjust icon size
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
                // Navigate to Settings Page
              },
        )
            )],
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
              color: Colors.black,
            ),
          ),
          Text(
            value?.toStringAsFixed(2) ?? 'N/A',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void addCalories(BuildContext context, dynamic product, CalorieCountProvider calorieCountProvider) async {
  // Retrieve calorie data
  double calories = 0.0;
  if (product.nutriments != null) {
    if ((product.nutriments?.energyServe ?? 0) > 0) {
      calories = product.nutriments!.energyServe!;
    } else {
      calories = product.nutriments?.energy ?? 0.0;
    }
  }

  // Fetch missing variables from the provider
  await calorieCountProvider.loadTargetsAsync();
  double newCalorieTotal = calorieCountProvider.calorieTotal ?? 0.0;

  newCalorieTotal += calories;

  // Update daily and weekly targets if available
  int newDailyTarget = calorieCountProvider.dailyTarget ?? 0;
  int newWeeklyTarget = calorieCountProvider.weeklyTarget ?? 0;

  // Update remaining daily and weekly calories
  double newRemainD = (calorieCountProvider.remainingCaloriesDaily ?? 0) - newCalorieTotal;
  double newRemainW = (calorieCountProvider.remainingCaloriesWeekly ?? 0) - newCalorieTotal;

  // Calculate daily progress
  double newProgDay = 0.0;
  if (newDailyTarget > 0) {
    double total = newDailyTarget - newRemainD;
    newProgDay = total / newDailyTarget;
    newProgDay = newProgDay.clamp(0.0, 1.0);
  }

  // Calculate weekly progress
  double newProgWeek = 0.0;
  if (newWeeklyTarget > 0) {
    double total = newWeeklyTarget - newRemainW;
    newProgWeek = total / newWeeklyTarget;
    newProgWeek = newProgWeek.clamp(0.0, 1.0);
  }

  // Create a CalorieCount object
  final calorieCount = CalorieCount(
    name: product.productName ?? "Unknown Product",
    calories: calories,
    salt: product.nutriments?.salt ?? 0.0,
    sugar: product.nutriments?.sugars ?? 0.0,
    protein: product.nutriments?.proteinsServe ?? 0.0,
    fat: product.nutriments?.fat ?? 0.0,
    satFat: product.nutriments?.saturatedFat ?? 0.0,  
    month: DateTime.now().month, // Ensure this is an int
    date: DateTime.now().day, // Ensure this is an int
    dayOfWeek:  DateFormat('EEEE').format(DateTime.now()), // Updated to return the day name
    weeklyTarget: newWeeklyTarget, // Already an int
    dailyTarget: newDailyTarget, // Already an int
    calorieTotals: newCalorieTotal, // This is a double, ensure the model accepts double
    remainingCaloriesDaily: newRemainD, // This is a double, ensure the model accepts double
    remainingCaloriesWeekly: newRemainW, // This is a double, ensure the model accepts double
    progressDaily: newProgDay, // This is a double, ensure the model accepts double
    progressWeekly: newProgWeek, // This is a double, ensure the model accepts double
  );

  // Save calorie data to the database
  await DatabaseService().saveCalorieCount(calorieCount);

  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Calorie data has been added to the database.")),
  );
}
}