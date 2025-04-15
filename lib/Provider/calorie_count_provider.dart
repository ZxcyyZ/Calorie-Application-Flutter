import 'package:flutter/material.dart';
import 'package:firstflutterapp/Models/database_model.dart'; // Import the CalorieCount model
import 'package:firstflutterapp/Services/database_service.dart'; // Import the DatabaseService

class CalorieCountProvider extends ChangeNotifier {
  // Private fields for storing property values
  int _weeklyTarget = 0;
  int _dailyTarget = 0;
  int _calorieTotal = 0;
  double _remainingCaloriesDaily = 0;
  double _remainingCaloriesWeekly = 0;
  double _dailyProgressValue = 0;
  double _weeklyProgressValue = 0;

  // Getters for accessing the properties
  int get weeklyTarget => _weeklyTarget;
  int get dailyTarget => _dailyTarget;
  int get calorieTotal => _calorieTotal;
  double get remainingCaloriesDaily => _remainingCaloriesDaily;
  double get remainingCaloriesWeekly => _remainingCaloriesWeekly;
  double get dailyProgressValue => _dailyProgressValue;
  double get weeklyProgressValue => _weeklyProgressValue;

  // Method to load today's calorie counts
Future<void> loadTodayCalorieCountsAsync() async {
  try {
    // Fetch today's calorie counts from the database
    final todayCalorieCounts = await DatabaseService().getCalorieCounts();

    // Safely parse the calorie values and calculate the total
    _calorieTotal = todayCalorieCounts.fold(0, (sum, item) {
      try {
        return sum + int.parse(item.calories);
      } catch (e) {
        debugPrint('Invalid calorie value: ${item.calories}');
        return sum; // Skip invalid values
      }
    });

    notifyListeners();
  } catch (e) {
    debugPrint('Error loading today\'s calorie counts: $e');
  }
}

  // Method to load daily and weekly targets
  Future<void> loadTargetsAsync() async {
    try {
      // Fetch the latest daily and weekly targets from the database
      _dailyTarget = await DatabaseService().getLatestDailyTarget() ?? 0;
      _weeklyTarget = await DatabaseService().getLatestWeeklyTarget() ?? 0;

      // Fetch the remaining daily and weekly calories
      _remainingCaloriesDaily = await DatabaseService().getRemainingCaloriesDaily() ?? 0;
      _remainingCaloriesWeekly = await DatabaseService().getRemainingCaloriesWeekly() ?? 0;

      // Fetch the daily and weekly progress values
      _dailyProgressValue = await DatabaseService().getProgressDaily() ?? 0;
      _weeklyProgressValue = await DatabaseService().getProgressWeekly() ?? 0;

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading targets: $e');
    }
  }

  // Method to clear all calorie counts
  Future<void> clearCalorieCountsAsync() async {
    try {
      await DatabaseService().clearCalorieCounts();
      _calorieTotal = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing calorie counts: $e');
    }
  }

  // Method to save or update calorie targets
  Future<void> saveOrUpdateTargets(int dailyTarget, int weeklyTarget) async {
    try {
      final now = DateTime.now();
      await DatabaseService().saveOrUpdateCalories(
        name: 'Calorie Targets',
        calories: 0,
        day: now.day,
        month: now.month,
        dayOfWeek: now.weekday.toString(),
        weeklyTarget: weeklyTarget,
        dailyTarget: dailyTarget,
      );
      debugPrint('Targets saved successfully!');
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving targets: $e');
    }
  }

  // Method to increment calories
  void incrementCalories(int amount) {
    _calorieTotal += amount;
    notifyListeners();
  }

  // Method to update progress values
  void updateProgress() {
    _dailyProgressValue = (_dailyTarget - _remainingCaloriesDaily) / _dailyTarget;
    _weeklyProgressValue = (_weeklyTarget - _remainingCaloriesWeekly) / _weeklyTarget;
    notifyListeners();
  }
}