import 'package:firstflutterapp/Services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstflutterapp/Provider/calorie_count_provider.dart';
import 'package:firstflutterapp/Views/set_calories_page.dart';
import 'package:firstflutterapp/Views/set_target_page.dart';

class CaloriePage extends StatelessWidget {
  const CaloriePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalorieCountProvider()..loadTargetsAsync()..loadTodayCalorieCountsAsync(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Row(
            children: [
              const SizedBox(width: 10),
              const Text(
                'Calorie Calculator',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: Consumer<CalorieCountProvider>(
          builder: (context, provider, child) {
            final dailyGoal = provider.dailyTarget;
            debugPrint('Daily Goal: $dailyGoal');
            final dailyRemaining = provider.remainingCaloriesDaily;
            final weeklyGoal = provider.weeklyTarget;
            final weeklyRemaining = provider.remainingCaloriesWeekly;

            final dailyProgress = dailyGoal > 0
                ? (dailyGoal - dailyRemaining) / dailyGoal
                : 0.0;
            final weeklyProgress = weeklyGoal > 0
                ? (weeklyGoal - weeklyRemaining) / weeklyGoal
                : 0.0;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daily Calories Box
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Calories',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Goal: $dailyGoal kcal',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Remaining: $dailyRemaining kcal',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: dailyProgress,
                              backgroundColor: Colors.grey[300],
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Reduced spacing between the two boxes

                    // Weekly Calories Box
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Weekly Calories',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Goal: $weeklyGoal kcal',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Remaining: $weeklyRemaining kcal',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: weeklyProgress,
                              backgroundColor: Colors.grey[300],
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Buttons Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final dbservice = DatabaseService();
                            dbservice.clearCalorieCounts();
                            debugPrint('Database cleared');

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SetTargetPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'Set Target',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SetCaloriesPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'Add Food',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
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
      ),
    );
  }
}