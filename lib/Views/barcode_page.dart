import 'package:firstflutterapp/Provider/calorie_count_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:provider/provider.dart';
import 'package:firstflutterapp/Provider/product_api_provider.dart';
import 'package:firstflutterapp/Models/database_model.dart';
import 'package:firstflutterapp/Views/main_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:firstflutterapp/Services/database_service.dart'; 
import 'package:intl/intl.dart';


class BarcodePage extends StatefulWidget {
  const BarcodePage({super.key});

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  final Zxing zx = Zxing(); // Initialize the Zxing instance
  String lastDetectedBarcode = ''; // Track the last detected barcode
  DateTime lastDetectedTime = DateTime.now(); // Track the last detection time
  bool detected = false; // Track if a barcode was detected

  @override
  void dispose() {
    zx.stopCameraProcessing(); // Stop camera processing when the page is disposed
    super.dispose();
  }

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
          'Barcode Scanner',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Instruction Label
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Scan the barcode inside the square frame to search for items.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Barcode Scanner Section
          Expanded(
            child: ReaderWidget(
              onScan: (result) async {
                // Ignore duplicate scans within 5 seconds
                if (result.text == lastDetectedBarcode &&
                    DateTime.now().difference(lastDetectedTime) <
                        const Duration(seconds: 5)) {
                  return result;
                }

                if(result.isValid){
                  debugPrint('Scanned barcode: ${result.text}');
                }
                lastDetectedBarcode = result.text.toString();
                lastDetectedTime = DateTime.now();

                // Fetch product information using the scanned barcode
                productProvider.barcode = result.text.toString();
                debugPrint('Scanned Barcode Provider Saved: ${productProvider.barcode}');
                await productProvider.fetchProductInfo();

                // Display product information
                if (productProvider.product != null) {
                  detected = false;
                  final product = productProvider.product!;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Product Info'),
                      content: Text(
                        'Name: ${product.productName ?? 'N/A'}\n'
                        'Total Calories (kJ): ${product.nutriments?.energy ?? 'N/A'}\n'
                        'Calories Per Serving (kJ): ${product.nutriments?.energyServe ?? 'N/A'}\n'
                        'Salt (g): ${product.nutriments?.salt ?? 'N/A'}\n'
                        'Sugars (g): ${product.nutriments?.sugars ?? 'N/A'}\n'
                        'Protein per 100g (g): ${product.nutriments?.proteinsServe ?? 'N/A'}\n'
                        'Fat (g): ${product.nutriments?.fat ?? 'N/A'}\n'
                        'Saturated Fat (g): ${product.nutriments?.saturatedFat ?? 'N/A'} \n \n'
                        'Would you like to add this product to your daily calorie count?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () { 
                            Navigator.pop(context);
                          setState(() {
                            detected = true;
                          });
                          addCalories(context, product, calorieCountProvider);
                          },
                          child: const Text('Yes'),
                        
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle "Yes" action
                            Navigator.pop(context);
                            setState(() {
                              detected = true;
                            });
                          },
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product not found!')),
                  );
                }

                detected = true;
              },
            ),
          ),
          const SizedBox(height: 20),

          // Buttons Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Information Button
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Pressing Scan Barcode will allow the camera to scan for barcodes for 5 seconds.',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.info, color: Colors.white, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
      }
    );
  }
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