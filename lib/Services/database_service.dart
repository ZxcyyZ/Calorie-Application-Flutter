import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firstflutterapp/Models/database_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;

  static const int _databaseVersion = 7; // Increment this version for schema updates
  static const String _databaseName = 'calorie_tracker7.db';

  /// Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Create and open the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        // Initial table creation
        await db.execute('''
          CREATE TABLE CalorieCount (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            calories REAL,
            activityType TEXT,
            subActivityType TEXT,
            salt REAL,
            sugar REAL, 
            protein REAL,
            fat REAL,
            satFat REAL,
            month INTEGER,
            date INTEGER,
            dayOfWeek TEXT,
            weeklyTarget INTEGER,
            dailyTarget INTEGER,
            calorieTotals REAL,
            remainingCaloriesDaily REAL,
            remainingCaloriesWeekly REAL,
            progressDaily REAL,
            progressWeekly REAL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion <= 5) {
          await db.execute('ALTER TABLE CalorieCount RENAME TO CalorieCount_old');

          await db.execute('''
            CREATE TABLE CalorieCount (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              calories REAL,
              month INTEGER,
              date INTEGER,
              dayOfWeek TEXT,
              weeklyTarget INTEGER,
              dailyTarget INTEGER,
              calorieTotals REAL,
              remainingCaloriesDaily REAL,
              remainingCaloriesWeekly REAL,
              progressDaily REAL,
              progressWeekly REAL
            )
          ''');

          await db.execute('''
            INSERT INTO CalorieCount (id, name, calories, month, date, dayOfWeek, weeklyTarget, dailyTarget, calorieTotals, remainingCaloriesDaily, remainingCaloriesWeekly, progressDaily, progressWeekly)
            SELECT id, name, CAST(calories AS REAL), month, date, dayOfWeek, weeklyTarget, dailyTarget, CAST(calorieTotals AS REAL), CAST(remainingCaloriesDaily AS REAL), CAST(remainingCaloriesWeekly AS REAL), CAST(progressDaily AS REAL), CAST(progressWeekly AS REAL)
            FROM CalorieCount_old
          ''');

          await db.execute('DROP TABLE CalorieCount_old');
        }
      },
    );
  }

  Future<List<CalorieCount>> getCalorieCounts({DateTime? selectedDate}) async {
    final db = await database;
    final targetDate = selectedDate ?? DateTime.now();
    // Query the database for all records matching today's date and month
    final results = await db.query(
      'CalorieCount',
      where: 'date = ? AND month = ?',
      whereArgs: [targetDate.day, targetDate.month],
    );

    // Map all results to a list of CalorieCount objects
    return results.map((e) => CalorieCount.fromMap(e)).toList();
}

  /// Save or update a CalorieCount record
Future<int> saveCalorieCount(CalorieCount calorieCount) async {
  final db = await database;

  if (calorieCount.id != null) {
    // Debug: Log the record being updated
    print('Updating record: ${calorieCount.toMap()}');

    // Update existing record
    return await db.update(
      'CalorieCount',
      calorieCount.toMap(),
      where: 'id = ?',
      whereArgs: [calorieCount.id],
    );
  } else {
    // Debug: Log the record being inserted
    print('Inserting new record: ${calorieCount.toMap()}');

    // Insert new record
    return await db.insert('CalorieCount', calorieCount.toMap());
  }
}

  /// Clear all records from the CalorieCount table
  Future<void> clearCalorieCounts() async {
    final db = await database;
    await db.delete('CalorieCount');
  }

  Future<void> saveOrUpdateCalories({
    required String name,
    required double calories,
    required double caloriesTotals,
    required int day,
    required int month,
    required String dayOfWeek,
    required int weeklyTarget,
    required int dailyTarget,
    required double remainingCaloriesDaily,
    required double remainingCaloriesWeekly,
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
      existingRecord.calories = (existingRecord.calories) + calories; // Ensure this remains a double
      await saveCalorieCount(existingRecord);
      print('Updated record: ${existingRecord.toMap()}');
    } else {
      // Create a new record
      final newRecord = CalorieCount(
        id: null, // Auto-incremented by the database
        name: name,
        calories: calories, // Ensure this is a double
        activityType: null,
        subActivityType: null,
        salt: 0.0,
        sugar: 0.0,
        protein: 0.0, 
        fat: 0.0,
        satFat: 0.0,
        date: day,
        month: month,
        dayOfWeek: dayOfWeek,
        weeklyTarget: weeklyTarget,
        dailyTarget: dailyTarget,
        calorieTotals: caloriesTotals,
        remainingCaloriesDaily: remainingCaloriesDaily,
        remainingCaloriesWeekly: remainingCaloriesWeekly,
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

  /// Retrieve the latest calorie value
  Future<double?> getLatestCalories() async {
    final db = await database;
    final result = await db.query(
      'CalorieCount',
      orderBy: 'id DESC', // Get the most recent entry
      limit: 1, // Limit to one result
    );

    if (result.isNotEmpty) {
      final latestCalories = double.tryParse(result.first['calories'] as String);
      print('Latest Calories: $latestCalories');
      return latestCalories;
    }

    print('No calorie data found in the database.');
    return null; // Return null if no data is found
  }
}