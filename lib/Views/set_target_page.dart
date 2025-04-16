import 'package:firstflutterapp/Services/database_service.dart';
import 'package:flutter/material.dart';

class SetTargetPage extends StatefulWidget {
  const SetTargetPage({super.key});

  @override
  State<SetTargetPage> createState() => _SetTargetPageState();
}

class _SetTargetPageState extends State<SetTargetPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String selectedGender = 'Male'; // Default gender selection

  // Save to database with daily and weekly remaining calories
  Future<void> saveToDatabase(int dailyTarget, int weeklyTarget) async {
    try {
      // Import the database service
      final DatabaseService dbService = DatabaseService();

      final now = DateTime.now();
      final dayOfWeek = now.weekday.toString();

      // Save or update the calorie targets using the database service
      await dbService.saveOrUpdateCalories(
        name: 'Calorie Targets', // Name for the record
        calories: 0, // No calories to save for targets
        day: now.day,
        month: now.month,
        dayOfWeek: dayOfWeek,
        weeklyTarget: weeklyTarget,
        dailyTarget: dailyTarget,
        remainingCaloriesDaily: dailyTarget, // Set daily remaining to match daily target
        remainingCaloriesWeekly: weeklyTarget, // Set weekly remaining to match weekly target
      );

      // Debug lines to display the saved targets
      debugPrint('Daily Target Saved: $dailyTarget kcal');
      debugPrint('Weekly Target Saved: $weeklyTarget kcal');
      debugPrint('Daily Remaining Saved: $dailyTarget kcal');
      debugPrint('Weekly Remaining Saved: $weeklyTarget kcal');

      final savedData = await dbService.getLatestDailyTarget(); // Replace with your actual database fetch method
      final savedWeeklyData = await dbService.getLatestWeeklyTarget(); // Replace with your actual database fetch method

      // Display the fetched data in the debug console
      if (savedData != null) {
        debugPrint('Fetched Data from Database:');
        debugPrint('Daily Target: ${savedData} kcal');
        debugPrint('Weekly Target: ${savedWeeklyData} kcal');
      } else {
        debugPrint('No data found in the database.');
      }

      debugPrint('Saved successfully to the database!');
    } catch (e) {
      debugPrint('Error saving to the database: $e');
    }
  }

  void calculateCalorieTarget() async {
    final ageText = ageController.text;
    final heightText = heightController.text;
    final weightText = weightController.text;

    // Validate inputs
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

    final age = int.tryParse(ageText);
    final height = double.tryParse(heightText);
    final weight = double.tryParse(weightText);

    if (age == null || height == null || weight == null) {
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

    if (age <= 0 || height <= 0 || weight <= 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Age, height, and weight must be greater than zero.'),
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

    // Calculate BMR using the provided formulas
    double bmr;
    if (selectedGender == 'Male') {
      bmr = 66.5 + (13.75 * weight) + (5.003 * height) - (6.75 * age);
    } else {
      bmr = 655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * age);
    }

    final dailyTarget = (bmr * 1.2).round(); // Assuming sedentary activity level
    final weeklyTarget = dailyTarget * 7;

    // Save the targets to the database
    await saveToDatabase(dailyTarget, weeklyTarget);

    // Show success dialog
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
                  onPressed: calculateCalorieTarget,
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
                Navigator.pushNamed(context, '/homePage'); // Navigate to the home page
              },
            ),
            // Barcode Scanner Button
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, size: 40),
              color: Colors.orange,
              onPressed: () {
                Navigator.pushNamed(context, '/barcodePage'); // Navigate to the barcode scanner page
              },
            ),
            // Settings Button
            IconButton(
              icon: const Icon(Icons.settings, size: 40),
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/settingsPage'); // Navigate to the settings page
              },
            ),
          ],
        ),
      ),
    );
  }
}