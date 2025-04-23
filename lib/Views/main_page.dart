import 'package:firstflutterapp/Views/barcode_page.dart';
import 'package:firstflutterapp/Views/calorie_page.dart';
import 'package:firstflutterapp/Views/nutrition_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:firstflutterapp/Views/gym_calculator_page.dart';
import 'package:firstflutterapp/Provider/calorie_count_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {  
  @override
  void initState() {
    super.initState();
  }

@override
Widget build(BuildContext context) {
return ChangeNotifierProvider<CalorieCountProvider>(
          create: (_) => CalorieCountProvider()..calculateNutritionDailyTotals()..loadTargetsAsync()..loadTodayCalorieCountsAsync(),
          builder: (context, child) {
             final calorieProvider = Provider.of<CalorieCountProvider>(context, listen: false);

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.orange,
      title: Row(
        children: [
          const SizedBox(width: 10),
          const Text(
            'NutriTrack',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
    child: Column(
      children: [
        // Use Consumer to listen for changes in CalorieCountProvider
        Consumer<CalorieCountProvider>(
          builder: (context, calorieProvider, child) {
            return _buildCustomCard(
              title: 'Daily Nutrition Overview',
              description: 'Track your daily nutrition intake',
              icon: Icons.today,
              hasCalorieData: true,
              dataSets: [
                List.generate(calorieProvider.todayCalorieCounts.length, (index) => FlSpot(index.toDouble(), calorieProvider.todayCalorieCounts[index].salt.toDouble())),
                List.generate(calorieProvider.todayCalorieCounts.length, (index) => FlSpot(index.toDouble(), calorieProvider.todayCalorieCounts[index].sugar.toDouble())), 
                List.generate(calorieProvider.todayCalorieCounts.length, (index) => FlSpot(index.toDouble(), calorieProvider.todayCalorieCounts[index].fat.toDouble())),
                List.generate(calorieProvider.todayCalorieCounts.length, (index) => FlSpot(index.toDouble(), calorieProvider.todayCalorieCounts[index].satFat.toDouble())),
                List.generate(calorieProvider.todayCalorieCounts.length, (index) => FlSpot(index.toDouble(), calorieProvider.todayCalorieCounts[index].protein.toDouble())),
              ],
              salt: calorieProvider.salt,
              protein: calorieProvider.protein,
              fat: calorieProvider.fat,
              saturatedFat: calorieProvider.satFat,
              sugar: calorieProvider.sugar,
              dailyCalories: calorieProvider.dailyTarget, 
            );
          },
        ),
        const SizedBox(height: 16),
        // Buttons Section (moved below the cards)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              icon: Icons.calculate,
              label: 'Calorie\n Calculator',
              onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CaloriePage()),

                );
              },
            ),
            _buildActionButton(
              icon: Icons.info,
              label: 'Exercise\n Calculator',
              onPressed: () {
                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const GymProgressionPage()),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    ),
  ),
),
    bottomNavigationBar: BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 150,
            height: 100,
            child: IconButton(
              icon: const Icon(Icons.search, size: 40),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const NutritionPage()),
                );
              },
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BarcodePage()),
                );
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.qr_code_scanner, size: 40, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 150,
            height: 100,
            child: IconButton(
              icon: const Icon(Icons.settings, size: 40),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
);
}
Widget _buildActionButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: 160, // Fixed width
    height: 160, // Fixed height
    
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Slightly rounded corners
        ),
        padding: const EdgeInsets.all(8), // Adjust padding for content
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
Widget _buildCustomCard({
  required String title,
  required String description,
  required IconData icon,
  bool hasCalorieData = false, // Indicates if calorie data is available
  List<List<FlSpot>>? dataSets, // Multiple datasets for the line graph
  double? salt, // Our values
  double? protein,
  double? saturatedFat,
  double? fat,
  double? sugar,
  required int dailyCalories, // Pass the daily calorie target
}) {
  // Dynamically calculate recommended values based on dailyCalories
  final double recommendedSugarMax = (dailyCalories * 0.10) / 4; // 10% of daily calories
  final double recommendedFatMin = (dailyCalories * 0.25) / 9; // 25% of daily calories
  final double recommendedSaturatedFat = (dailyCalories * 0.10) / 9; // 10% of daily calories

  print('target calories: $dailyCalories');

  // Fixed recommended salt and protein values
  const double recommendedSalt = 6.0; // in grams
  const double recommendedProtein = 50.0; // in grams

  Color getColor(double? intake, double recommended) {
    if (intake == null) return Colors.grey; // Default color for missing data
    if (intake <= recommended) return Colors.green; // Below or equal to recommended
    if (intake <= recommended * 1.10) return Colors.orange; // Within 10% over recommended
    return Colors.red; // More than 10% over recommended
  }

  return SizedBox(
    height: 500, // Increased height to accommodate additional information
    width: double.infinity, // Full width of the parent
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 50, color: Colors.orange),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Conditional rendering of the line graph or "No calorie data set" message
            Expanded(
  child: hasCalorieData && dataSets != null
      ? LineChart(
          LineChartData(
            gridData: FlGridData(show: true), // Show grid lines
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(), // Y-axis labels
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    // Dynamically generate labels based on product indices
                    final index = value.toInt();
                    if (index >= 0 && index < dataSets[0].length) {
                      return Text(
                        'P$index', // Example: P0, P1, P2 (Product indices)
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            lineBarsData: dataSets.map((dataPoints) {
              return LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                color: [Colors.blue, Colors.orange, Colors.green, Colors.red, Colors.yellow][dataSets.indexOf(dataPoints) % 5],
                barWidth: 4,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              );
            }).toList(),
            minX: 0, // Start of the horizontal axis
            maxX: (dataSets[0].length - 1).toDouble(), // End of the horizontal axis
            minY: 0, // Start of the vertical axis
          ),
        )
      : const Center(
          child: Text(
            'No calorie data set',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
),
            const SizedBox(height: 16),
            // Additional Information Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nutrition Values (Recommended vs. Intake):',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Display recommended vs. actual values
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Salt: ${recommendedSalt.toStringAsFixed(1)} g'),
                    Row(
                      children: [
                        const Text('Intake: '), // Static text
                        Text(
                          '${salt?.toStringAsFixed(1) ?? 'N/A'} g', // Dynamic number
                          style: TextStyle(color: getColor(salt, recommendedSalt)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Protein: ${recommendedProtein.toStringAsFixed(1)} g'),
                    Row(
                      children: [
                        const Text('Intake: '), // Static text
                        Text(
                          '${protein?.toStringAsFixed(1) ?? 'N/A'} g', // Dynamic number
                          style: TextStyle(color: getColor(protein, recommendedProtein)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fat: ${recommendedFatMin.toStringAsFixed(1)} g'),
                    Row(
                      children: [
                        const Text('Intake: '), // Static text
                        Text(
                          '${fat?.toStringAsFixed(1) ?? 'N/A'} g', // Dynamic number
                          style: TextStyle(color: getColor(fat, recommendedFatMin)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Saturated Fat: ${recommendedSaturatedFat.toStringAsFixed(1)} g'),
                    Row(
                      children: [
                        const Text('Intake: '), // Static text
                        Text(
                          '${saturatedFat?.toStringAsFixed(1) ?? 'N/A'} g', // Dynamic number
                          style: TextStyle(color: getColor(saturatedFat, recommendedSaturatedFat)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sugar: ${recommendedSugarMax.toStringAsFixed(1)} g'),
                    Row(
                      children: [
                        const Text('Intake: '), // Static text
                        Text(
                          '${sugar?.toStringAsFixed(1) ?? 'N/A'} g', // Dynamic number
                          style: TextStyle(color: getColor(sugar, recommendedSugarMax)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}
