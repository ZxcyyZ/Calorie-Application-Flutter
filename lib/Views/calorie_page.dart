import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstflutterapp/Provider/calorie_count_provider.dart';
import 'package:firstflutterapp/Views/set_calories_page.dart';
import 'package:firstflutterapp/Views/set_target_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:firstflutterapp/Models/database_model.dart';
import 'package:firstflutterapp/Views/main_page.dart';
import 'package:intl/intl.dart';

class CaloriePage extends StatefulWidget {
  const CaloriePage({super.key});

  @override
  State<CaloriePage> createState() => _CaloriePageState();
}

class _CaloriePageState extends State<CaloriePage> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalorieCountProvider()..loadTargetsAsync()..loadTodayCalorieCountsAsync()..checkAndResetTargets(),
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
                    const SizedBox(height: 20),

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
                        // Calendar Icon Button
                        IconButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (selectedDate != null) {
                              debugPrint('Selected Date: ${selectedDate.toIso8601String()}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected Date: ${selectedDate.toLocal()}'),
                                ),
                                
                              );
                              setState(() {
                                _selectedDate = selectedDate; 
                              });
                              await Provider.of<CalorieCountProvider>(context, listen: false)
                                  .loadTodayCalorieCountsAsync(selectedDate: _selectedDate);
                            }
                          },
                          icon: const Icon(Icons.calendar_today, size: 40, color: Colors.blue),
                          tooltip: 'Pick a Date',
                        ),
                        ElevatedButton(
                          onPressed: () {
                            provider.clearCalorieCountsAsync();
                            debugPrint('Calorie counts cleared.');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const SetTargetPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const SetCaloriesPage()),
                          );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
                    const SizedBox(height: 20),

                    // ListView for Today's Tracked Calories
                     Center(
                      child: Text(
                        'Tracked Calories for ${DateFormat('MMMM d, yyyy').format(_selectedDate ?? DateTime.now())}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (provider.todayCalorieCounts.isEmpty) // Check if the list is empty
                       Center(
                        child: Text(
                          'No calories tracked for ${DateFormat('MMMM d, yyyy').format(_selectedDate ?? DateTime.now())}.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.todayCalorieCounts.length, // Use the provider's list
                        itemBuilder: (context, index) {
                          final entry = provider.todayCalorieCounts[index];
                          return ExpandableTile(entry: entry);
                        },
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
              IconButton(
                icon: const Icon(Icons.home, size: 40),
                color: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                  },
              ),
              IconButton(
                icon: const Icon(Icons.settings, size: 40),
                color: Colors.white,
                onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Define a new StatefulWidget for the expandable tile
class ExpandableTile extends StatefulWidget {
  final CalorieCount entry;

  const ExpandableTile({Key? key, required this.entry}) : super(key: key);

  @override
  _ExpandableTileState createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.entry.name ?? 'Unknown Product',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${widget.entry.calories ?? 0} kcal',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            trailing: TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded; // Toggle the expanded state
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Text color
              ),
              child: Text(
                _isExpanded ? 'Collapse' : 'Expand',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
                if (_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.entry.name == "Exercise") ...[
                    _buildInfoRow('Date', '${widget.entry.date ?? 'Unknown Date'}/${widget.entry.month ?? 'Unknown Month'}'),
                    _buildInfoRow('Day of the Week', widget.entry.dayOfWeek ?? 'Unknown Day'),
                    _buildInfoRow('Activity Type', widget.entry.activityType ?? 'Unknown Activity'),
                    _buildInfoRow('Sub-Activity Type', widget.entry.subActivityType ?? 'Unknown Sub-Activity'),
                    _buildInfoRow('Calories Burned', '${widget.entry.calories ?? 0} kcal'),
                  ] else ...[
                    _buildInfoRow('Date', '${widget.entry.date ?? 'Unknown Date'}/${widget.entry.month ?? 'Unknown Month'}'),
                    _buildInfoRow('Day of the Week', widget.entry.dayOfWeek ?? 'Unknown Day'),
                    _buildInfoRow('Salt', '${widget.entry.salt ?? 0} g'),
                    _buildInfoRow('Sugar', '${widget.entry.sugar ?? 0} g'),
                    _buildInfoRow('Protein per 100g', '${widget.entry.protein ?? 0} g'),
                    _buildInfoRow('Fat', '${widget.entry.fat ?? 0} g'),
                    _buildInfoRow('Saturated Fat', '${widget.entry.satFat ?? 0} g'),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
                

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
}