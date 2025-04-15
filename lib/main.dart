import 'package:firstflutterapp/Views/barcode_page.dart';
import 'package:firstflutterapp/Views/nutrition_page.dart';
import 'package:firstflutterapp/Views/set_calories_page.dart';
import 'package:firstflutterapp/Views/set_target_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/calorie_count_provider.dart';
import 'provider/settings_provider.dart';
import 'views/main_page.dart';
import 'views/calorie_page.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalorieCountProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'NutriTrack',
        theme: ThemeData(primarySwatch: Colors.orange),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainPage(),
          '/caloriePage': (context) => const CaloriePage(),
          '/barcodePage': (context) => const  BarcodePage(),
          '/settingsPage': (context) => const SettingsPage(),
          '/nutritionPage': (context) => const NutritionPage(),
          '/setTargetPage': (context) => const SetTargetPage(),  
          '/setCaloriePage': (context) => const SetCaloriesPage(),
        },
      ),
    );
  }
}