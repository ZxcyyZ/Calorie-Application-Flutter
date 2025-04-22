
/// This class saves all the database variables that are needed to save the data.
class CalorieCount {
  int? id; // Primary key, auto-increment
  String name; // Field for the name
  double calories; // Field for calories
  String? activityType;
  String? subActivityType;
  double salt;
  double sugar;
  double protein;
  double fat;
  double satFat;
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
    this.activityType,
    this.subActivityType,
    required this.salt,
    required this.sugar,
    required this.protein,
    required this.fat,
    required this.satFat,
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
      'activityType': activityType,
      'subActivityType': subActivityType,
      'calories': calories,
      'salt': salt,
      'sugar': sugar,
      'protein': protein,
      'fat': fat,
      'satFat': satFat,
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
      activityType: map['activityType'] as String?, 
      subActivityType: map['subActivityType'] as String?,
      salt: (map['salt'] as num).toDouble(),
      sugar: (map['sugar'] as num).toDouble(),
      protein: (map['protein'] as num).toDouble(),
      fat: (map['fat'] as num).toDouble(),
      satFat: (map['satFat'] as num).toDouble(),
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