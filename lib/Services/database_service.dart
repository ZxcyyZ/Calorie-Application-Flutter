import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firstflutterapp/Models/database_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;

  /// Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Create and open the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'caloriecount.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE CalorieCount (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            calories TEXT,
            month INTEGER,
            date INTEGER,
            dayOfWeek TEXT,
            weeklyTarget INTEGER,
            dailyTarget INTEGER,
            calorieTotals INTEGER,
            remainingCaloriesDaily REAL,
            remainingCaloriesWeekly REAL,
            progressDaily REAL,
            progressWeekly REAL
          )
        ''');
      },
    );
  }

  /// Retrieve calorie counts for the current day and month
  Future<List<CalorieCount>> getCalorieCounts() async {
    final db = await database;
    final today = DateTime.now();
    final maps = await db.query(
      'CalorieCount',
      where: 'date = ? AND month = ?',
      whereArgs: [today.day, today.month],
    );

    return maps.map((map) => CalorieCount.fromMap(map)).toList();
  }

  /// Save or update a CalorieCount record
  Future<int> saveCalorieCount(CalorieCount calorieCount) async {
    final db = await database;

    if (calorieCount.id != null) {
      // Update existing record
      return await db.update(
        'CalorieCount',
        calorieCount.toMap(),
        where: 'id = ?',
        whereArgs: [calorieCount.id],
      );
    } else {
      // Insert new record
      return await db.insert('CalorieCount', calorieCount.toMap());
    }
  }

  /// Clear all records from the CalorieCount table
  Future<void> clearCalorieCounts() async {
    final db = await database;
    await db.delete('CalorieCount');
  }

  /// Save or update calories for a specific date
  Future<void> saveOrUpdateCalories({
    required String name,
    required double calories,
    required int day,
    required int month,
    required String dayOfWeek,
    required int weeklyTarget,
    required int dailyTarget,
  }) async {
    final db = await database;

    // Check if a record exists for the specified date
    final existingRecords = await db.query(
      'CalorieCount',
      where: 'date = ? AND month = ?',
      whereArgs: [day, month],
    );

    if (existingRecords.isNotEmpty) {
      // Update the existing record
      final existingRecord = CalorieCount.fromMap(existingRecords.first);
      existingRecord.calories =
          (double.parse(existingRecord.calories) + calories).toString();
      await saveCalorieCount(existingRecord);
      print('Updated record: ${existingRecord.toMap()}');
    } else {
      // Create a new record
      final newRecord = CalorieCount(
        name: name,
        calories: calories.toString(),
        date: day,
        month: month,
        dayOfWeek: dayOfWeek,
        weeklyTarget: weeklyTarget,
        dailyTarget: dailyTarget,
        calorieTotals: 0,
        remainingCaloriesDaily: 0,
        remainingCaloriesWeekly: 0,
        progressDaily: 0,
        progressWeekly: 0,
      );
      await saveCalorieCount(newRecord);
      print('Inserted new record: ${newRecord.toMap()}');
    }
  }

  /// Retrieve the latest weekly target
  Future<int?> getLatestWeeklyTarget() async {
    final db = await database;
    final result = await db.query(
      'CalorieCount',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      print('Latest Weekly Target: ${result.first['weeklyTarget']}');
      return result.first['weeklyTarget'] as int?;
    }
    print('No Weekly Target found in the database.');
    return null;
  }

  /// Retrieve the latest daily target
  Future<int?> getLatestDailyTarget() async {
    final db = await database;
    final result = await db.query(
      'CalorieCount',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      print('Latest Daily Target: ${result.first['dailyTarget']}');
      return result.first['dailyTarget'] as int?;
    }
    print('No Daily Target found in the database.');
    return null;
  }

  /// Retrieve the latest calorie total
  Future<double?> getLatestCalorieTotal() async {
    final db = await database;
    final result = await db.query(
      'CalorieCount',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      final calorieTotal = double.tryParse(result.first['calories'] as String);
      print('Latest Calorie Total: $calorieTotal');
      return calorieTotal;
    }
    print('No Calorie Total found in the database.');
    return null;
  }

  /// Retrieve the remaining daily calories
  Future<double?> getRemainingCaloriesDaily() async {
    final db = await database;
    final result = await db.query(
      'CalorieCount',
      where: 'dailyTarget > 0',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      print('Remaining Daily Calories: ${result.first['remainingCaloriesDaily']}');
      return result.first['remainingCaloriesDaily'] as double?;
    }
    print('No Remaining Daily Calories found in the database.');
    return null;
  }

  /// Retrieve the remaining weekly calories
  Future<double?> getRemainingCaloriesWeekly() async {
    final db = await database;
    final result = await db.query(
      'CalorieCount',
      where: 'weeklyTarget > 0',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      print('Remaining Weekly Calories: ${result.first['remainingCaloriesWeekly']}');
      return result.first['remainingCaloriesWeekly'] as double?;
    }
    print('No Remaining Weekly Calories found in the database.');
    return null;
  }

  /// Retrieve the daily progress
  Future<double?> getProgressDaily() async {
    final db = await database;
    final result = await db.query(
      'CalorieCount',
      where: 'progressDaily > 0',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      print('Daily Progress: ${result.first['progressDaily']}');
      return result.first['progressDaily'] as double?;
    }
    print('No Daily Progress found in the database.');
    return null;
  }

  /// Retrieve the weekly progress
  Future<double?> getProgressWeekly() async {
    final db = await database;
    final result = await db.query(
      'CalorieCount',
      where: 'progressWeekly > 0',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      print('Weekly Progress: ${result.first['progressWeekly']}');
      return result.first['progressWeekly'] as double?;
    }
    print('No Weekly Progress found in the database.');
    return null;
  }
}