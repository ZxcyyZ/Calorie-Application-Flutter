import 'package:flutter/material.dart';
import 'package:firstflutterapp/Provider/calorie_count_provider.dart';
import 'package:firstflutterapp/Views/main_page.dart';
import 'package:provider/provider.dart';

/// The SettingsPage class represents the settings screen of the app.
/// It allows users to perform actions like clearing the database and navigating back to the main page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provides an instance of CalorieCountProvider to manage state within this page
      create: (_) => CalorieCountProvider(),
      child: Scaffold(
        appBar: AppBar(
          // AppBar with a title for the settings page
          title: Row(
            children: [
              const SizedBox(width: 10), // Adds spacing before the title
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange, // Sets the AppBar background color
        ),
        body: SingleChildScrollView(
          // Allows the content to be scrollable if it overflows
          child: Padding(
            padding: const EdgeInsets.all(25.0), // Adds padding around the content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the start
              children: [
                // Clear Database Button
                ElevatedButton(
                  onPressed: () {
                    // Action to clear the database (currently only shows a SnackBar)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Database cleared!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Button background color
                    padding: const EdgeInsets.symmetric(vertical: 15), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Clear Database',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 18, // Font size
                      fontWeight: FontWeight.bold, // Font weight
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Adds spacing after the button
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          // Bottom navigation bar, that creates a home button so you can retrun to main
          color: Colors.black, // Background color of the BottomAppBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the button
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigates back to the MainPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Button background color
                  ),
                  child: const Icon(
                    Icons.home, // Home icon
                    size: 40, // Icon size
                    color: Colors.white, // Icon color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}