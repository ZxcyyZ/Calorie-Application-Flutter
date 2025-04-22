import 'package:flutter/material.dart';
import 'package:firstflutterapp/Models/database_model.dart'; // Import the CalorieCount model
import 'package:firstflutterapp/Services/database_service.dart'; // Import the DatabaseService

class CalorieCountProvider extends ChangeNotifier {
  // Private fields for storing property values
  int _weeklyTarget = 0;
  int _dailyTarget = 0;
  double _calorieTotal = 0;
  double _remainingCaloriesDaily = 0;
  double _remainingCaloriesWeekly = 0;
  double _dailyProgressValue = 0;
  double _weeklyProgressValue = 0;
  List<CalorieCount> _todayCalorieCounts = [];

  // Getters for accessing the properties
  int get weeklyTarget => _weeklyTarget;
  int get dailyTarget => _dailyTarget;
  double get calorieTotal => _calorieTotal;
  double get remainingCaloriesDaily => _remainingCaloriesDaily;
  double get remainingCaloriesWeekly => _remainingCaloriesWeekly;
  double get dailyProgressValue => _dailyProgressValue;
  double get weeklyProgressValue => _weeklyProgressValue;
  List<CalorieCount> get todayCalorieCounts => _todayCalorieCounts; 

 Future<void> loadTodayCalorieCountsAsync({DateTime? selectedDate}) async {
  try {
    // Fetch all matching calorie counts from the database
    final todayCalorieCounts = await DatabaseService().getCalorieCounts();

    if (todayCalorieCounts != null && todayCalorieCounts.isNotEmpty) {
      final targetDate = selectedDate ?? DateTime.now();

      // Save all fetched data directly
      _todayCalorieCounts = todayCalorieCounts
          .where((entry) => 
              entry.name != 'Calorie Targets' && // Adjust the condition as needed
              entry.date == targetDate.day && entry.month == targetDate.month)
          .toList()
          .reversed
          .toList();
      // Debug: Print each calorie count in the list
      for (var item in _todayCalorieCounts) {
        debugPrint('Stored calorie record: ${item.toString()}');
      }
    } else {
      // If no data is found, reset the values
      _todayCalorieCounts = [];
      debugPrint('No calorie records found for today.');
    }

    // Notify listeners of state changes
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