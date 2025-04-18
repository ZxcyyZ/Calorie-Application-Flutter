
/// This class saves all the database variables that are needed to save the data.
class CalorieCount {
  int? id; // Primary key, auto-increment
  String name; // Field for the name
  double calories; // Field for calories
  int month; // Field for the month
  int date; // Field for the date (e.g., 1st, 2nd, etc.)
  String dayOfWeek; // Field for the day (e.g., Monday, Tuesday, etc.)
  int weeklyTarget; // Field for the weekly target
  int dailyTarget; // Field for the daily target
  double calorieTotals; // Field for the total calories
  double remainingCaloriesDaily; // Field for the remaining daily calories
  double remainingCaloriesWeekly; // Field for the remaining weekly calories
  double progressDaily; // Field for the daily progress
  double progressWeekly; // Field for the weekly progress

  CalorieCount({
    this.id,
    required this.name,
    required this.calories,
    required this.month,
    required this.date,
    required this.dayOfWeek,
    required this.weeklyTarget,
    required this.dailyTarget,
    required this.calorieTotals,
    required this.remainingCaloriesDaily,
    required this.remainingCaloriesWeekly,
    required this.progressDaily,
    required this.progressWeekly,
  });

  /// Convert a `CalorieCount` object into a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'month': month,
      'date': date,
      'dayOfWeek': dayOfWeek,
      'weeklyTarget': weeklyTarget,
      'dailyTarget': dailyTarget,
      'calorieTotals': calorieTotals,
      'remainingCaloriesDaily': remainingCaloriesDaily,
      'remainingCaloriesWeekly': remainingCaloriesWeekly,
      'progressDaily': progressDaily,
      'progressWeekly': progressWeekly,
    };
  }

  /// Create a `CalorieCount` object from a Map (retrieved from the database).
  factory CalorieCount.fromMap(Map<String, dynamic> map) {
    return CalorieCount(
      id: map['id'] as int,
      name: map['name'] as String,
      calories: (map['calories'] as num).toDouble(),
      month: map['month'] as int,
      date: map['date'] as int,
      dayOfWeek: map['dayOfWeek'] as String,
      weeklyTarget: map['weeklyTarget'] as int, 
      dailyTarget: map['dailyTarget'] as int,
      calorieTotals: (map['calorieTotals'] as num).toDouble(),
      remainingCaloriesDaily: (map['remainingCaloriesDaily'] as num).toDouble(),
      remainingCaloriesWeekly: (map['remainingCaloriesWeekly'] as num).toDouble(),
      progressDaily: (map['progressDaily'] as num).toDouble(),
      progressWeekly: (map['progressWeekly'] as num).toDouble(),
    );
  }
}

/// This class is used to store the view data that is shared across the main page and the carousel view.
class ViewData {
  String viewType; // "Daily" or "Weekly"
  String target; // The target value (e.g., "1500" or "10500")
  String calorieTotal; // The total calories for the view
  String remainingCalories; // Remaining calories
  double progress; // The progress value (e.g., "50%")

  ViewData({
    required this.viewType,
    required this.target,
    required this.calorieTotal,
    required this.remainingCalories,
    required this.progress,
  });

  /// Convert a `ViewData` object into a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'viewType': viewType,
      'target': target,
      'calorieTotal': calorieTotal,
      'remainingCalories': remainingCalories,
      'progress': progress,
    };
  }

  /// Create a `ViewData` object from a Map (retrieved from the database).
  factory ViewData.fromMap(Map<String, dynamic> map) {
    return ViewData(
      viewType: map['viewType'],
      target: map['target'],
      calorieTotal: map['calorieTotal'],
      remainingCalories: map['remainingCalories'],
      progress: map['progress'],
    );
  }
}