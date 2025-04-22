import 'package:firstflutterapp/Views/barcode_page.dart';
import 'package:firstflutterapp/Views/calorie_page.dart';
import 'package:firstflutterapp/Views/nutrition_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:firstflutterapp/Views/gym_calculator_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
Widget build(BuildContext context) {
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
        // Custom Cards Section (moved above the buttons)
        _buildCustomCard(
          title: 'Daily Nutrition Overview',
          description: 'Track your daily nutrition intake',
          icon: Icons.today,
          hasCalorieData: true,
          dataSets: [
            [
              FlSpot(0, 10),
              FlSpot(1, 20),
              FlSpot(2, 30),
              FlSpot(3, 40),
              FlSpot(4, 50),
            ],
            [
              FlSpot(0, 5),
              FlSpot(1, 15),
              FlSpot(2, 25),
              FlSpot(3, 35),
              FlSpot(4, 45),
            ],
            [
              FlSpot(0, 2),
              FlSpot(1, 12),
              FlSpot(2, 22),
              FlSpot(3, 32),
              FlSpot(4, 42),
            ],
          ],
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CaloriePage()),
                );
              },
            ),
            _buildActionButton(
              icon: Icons.info,
              label: 'Exercise\n Calculator',
              onPressed: () {
                Navigator.push(
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
                Navigator.push(
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
                Navigator.push(
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
                Navigator.push(
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
}) {
  return SizedBox(
    height: 300, // Increased height
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
                                return Text(
                                  'Day ${value.toInt()}', // X-axis labels
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
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
                            color: Colors.primaries[dataSets.indexOf(dataPoints) % Colors.primaries.length], // Assign a unique color for each line
                            barWidth: 4,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(show: false),
                          );
                        }).toList(),
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
          ],
        ),
      ),
    ),
  );
}
}