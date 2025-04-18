import 'package:firstflutterapp/Views/barcode_page.dart';
import 'package:firstflutterapp/Views/calorie_page.dart';
import 'package:firstflutterapp/Views/nutrition_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:firstflutterapp/Views/gym_calculator_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            const SizedBox(width: 10),
            const Text(
              'NutriTrack',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Weekly Progress Section
              _buildProgressCard(
                title: 'Weekly Calories',
                goal: 'Weekly Goal',
                target: '2000', // Replace with dynamic data
                remaining: '1500 Calories Remaining For The Week',
                progress: 0.75, // Replace with dynamic progress value
              ),
              const SizedBox(height: 16),
              // Daily Progress Section
              _buildProgressCard(
                title: 'Daily Calories',
                goal: 'Daily Goal',
                target: '500', // Replace with dynamic data
                remaining: '300 Calories Remaining For Today',
                progress: 0.6, // Replace with dynamic progress value
              ),
              const SizedBox(height: 16),
              // Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.calculate,
                    label: 'Calorie Calculator',
                    onPressed: () {
                      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const CaloriePage()),
                );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.info,
                    label: 'Gym Progression',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GymProgressionPage()),
                      );
              
                      // Show Information Popup
                    },
                  ),
                ],
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
              icon: const Icon(Icons.search, size: 40),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const NutritionPage()),
                );
              },
            ),
            ),
            SizedBox(
              width: 100, // Adjust the width
              height: 100, // Adjust the height
              child: FloatingActionButton(
                     onPressed: () {
                       Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const BarcodePage()),
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
             Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const SettingsPage()),
                );
                // Navigate to Settings Page
              },
        )
            )],
        ),
      ),
    );
  }

    Widget _buildProgressCard({
    required String title,
    required String goal,
    required String target,
    required String remaining,
    required double progress,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Goal and Target Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  target,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Remaining Calories
            Text(
              remaining,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            // Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: 180, // Set a fixed width for all buttons
    height: 180, // Set a fixed height for all buttons
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.all(16), // Adjust padding as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 70, color: Colors.white), // Adjust icon size
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24, // Adjust font size
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
}