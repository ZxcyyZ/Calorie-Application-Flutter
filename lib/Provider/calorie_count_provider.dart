import 'package:flutter/material.dart';

class CalorieCountProvider extends ChangeNotifier {
  int _caloriesToday = 0;
  final int _weeklyTarget = 2000;

  int get caloriesToday => _caloriesToday;
  int get weeklyTarget => _weeklyTarget;

  Future<void> loadTodayCalorieCountsAsync() async {
    // Simulate loading data
    await Future.delayed(const Duration(seconds: 1));
    _caloriesToday = 1500; // Example data
    notifyListeners();
  }

  void incrementCalories(int amount) {
    _caloriesToday += amount;
    notifyListeners();
  }
}