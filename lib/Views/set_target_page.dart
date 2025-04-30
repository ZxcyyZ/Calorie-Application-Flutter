import 'package:firstflutterapp/Services/database_service.dart';
import 'package:firstflutterapp/Views/calorie_page.dart';
import 'package:firstflutterapp/Views/main_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:flutter/material.dart';

/// The SetTargetPage class allows users to input their details (age, height, weight, and gender)
/// to calculate their daily and weekly calorie targets and save them to the database.
class SetTargetPage extends StatefulWidget {
  const SetTargetPage({super.key});

  @override
  State<SetTargetPage> createState() => _SetTargetPageState();
}

class _SetTargetPageState extends State<SetTargetPage> {
  // Controllers for user input fields
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String selectedGender = 'Male'; // Default gender selection

  /// Saves the calculated daily and weekly calorie targets to the database.
  Future<void> saveToDatabase(int dailyTarget, int weeklyTarget) async {
    try {
      final DatabaseService dbService = DatabaseService(); // Database service instance
      final now = DateTime.now(); // Current date and time
      final dayOfWeek = now.weekday.toString(); // Current day of the week

      // Save or update the calorie targets in the database
      await dbService.saveOrUpdateCalories(
        name: 'Calorie Targets', // Record name
        calories: 0, // No calories to save for targets
        caloriesTotals: 0,
        day: now.day,
        month: now.month,
        dayOfWeek: dayOfWeek,
        weeklyTarget: weeklyTarget,
        dailyTarget: dailyTarget,
        remainingCaloriesDaily: dailyTarget.toDouble(), // Remaining daily calories
        remainingCaloriesWeekly: weeklyTarget.toDouble(), // Remaining weekly calories
      );

      // Debugging: Print saved targets to the console
      debugPrint('Daily Target Saved: $dailyTarget kcal');
      debugPrint('Weekly Target Saved: $weeklyTarget kcal');
    } catch (e) {
      // Handle errors during database save
      debugPrint('Error saving to the database: $e');
    }
  }

  /// Validates user input, calculates calorie targets, and saves them to the database.
  void calculateCalorieTarget() async {
    final ageText = ageController.text;
    final heightText = heightController.text;
    final weightText = weightController.text;

    // Validate that all fields are filled
    if (ageText.isEmpty || heightText.isEmpty || weightText.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in all fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Parse user input
    final age = int.tryParse(ageText);
    final height = double.tryParse(heightText);
    final weight = double.tryParse(weightText);

    // Validate that inputs are numeric and greater than zero
    if (age == null || height == null || weight == null || age <= 0 || height <= 0 || weight <= 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter valid numeric values for age, height, and weight.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Calculate BMR (Basal Metabolic Rate) based on gender
    double bmr;
    if (selectedGender == 'Male') {
      bmr = 66.5 + (13.75 * weight) + (5.003 * height) - (6.75 * age);
    } else {
      bmr = 655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * age);
    }

    // Calculate daily and weekly calorie targets
    final dailyTarget = (bmr * 1.2).round(); // Assuming sedentary activity level
    final weeklyTarget = dailyTarget * 7;

    // Save the targets to the database
    await saveToDatabase(dailyTarget, weeklyTarget);

    // Show success dialog with calculated targets
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calorie Target'),
        content: Text(
          'Based on your inputs:\n'
          'Daily Calorie Target: $dailyTarget kcal\n'
          'Weekly Calorie Target: $weeklyTarget kcal\n\n'
          'Your targets have been saved successfully!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Set Target',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                'Enter your details below to calculate your daily and weekly calorie targets.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Gender Dropdown
              const Text(
                'Gender',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedGender = value;
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
              const SizedBox(height: 20),

              // Age Input
              const Text(
                'Age (years)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  hintText: 'Enter your age',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Height Input
              const Text(
                'Height (cm)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: heightController,
                decoration: InputDecoration(
                  hintText: 'Enter your height in cm',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Weight Input
              const Text(
                'Weight (kg)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  hintText: 'Enter your weight in kg',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Calculate Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    calculateCalorieTarget();

                    // Navigate to the CaloriePage after calculation
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CaloriePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Calculate Target',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
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
}