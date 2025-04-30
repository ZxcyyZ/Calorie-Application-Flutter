import 'package:firstflutterapp/Views/barcode_page.dart';
import 'package:firstflutterapp/Views/nutrition_page.dart';
import 'package:firstflutterapp/Views/set_calories_page.dart';
import 'package:firstflutterapp/Views/set_target_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:firstflutterapp/Views/gym_calculator_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/calorie_count_provider.dart';
import 'provider/product_api_provider.dart';
import 'provider/settings_provider.dart';
import 'views/main_page.dart';
import 'views/calorie_page.dart';

void main() {
  // Disable debug checks for invalid value types in Provider (optional)
  Provider.debugCheckInvalidValueType = null;

  // Entry point of the Flutter application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Register multiple providers for state management
      providers: [
        ChangeNotifierProvider(create: (_) => CalorieCountProvider()), // Manages calorie-related data
        ChangeNotifierProvider(create: (_) => SettingsProvider()), // Manages app settings
        ChangeNotifierProvider(create: (_) => ProductApiProvider()), // Manages product API interactions
      ],
      child: MaterialApp(
        title: 'NutriTrack', // App title
        theme: ThemeData(primarySwatch: Colors.orange), // App theme with orange as the primary color
        initialRoute: '/', // Initial route when the app starts
        routes: {
          // Define named routes for navigation
          '/': (context) => const MainPage(), // Main page of the app
          '/caloriePage': (context) => const CaloriePage(), // Page for calorie tracking
          '/barcodePage': (context) => const BarcodePage(), // Page for barcode scanning
          '/settingsPage': (context) => const SettingsPage(), // Page for app settings
          '/nutritionPage': (context) => const NutritionPage(), // Page for nutrition details
          '/setTargetPage': (context) => const SetTargetPage(), // Page for setting calorie targets
          '/setCaloriePage': (context) => const SetCaloriesPage(), // Page for setting calorie intake
          '/gymProgressionpage': (context) => const GymProgressionPage(), // Page for gym progression tracking
        },
      ),
    );
  }
}