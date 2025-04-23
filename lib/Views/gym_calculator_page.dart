import 'package:firstflutterapp/Models/database_model.dart';
import 'package:firstflutterapp/Views/main_page.dart';
import 'package:firstflutterapp/Views/settings_page.dart';
import 'package:firstflutterapp/Provider/calorie_count_provider.dart';
import 'package:flutter/material.dart';
import 'package:firstflutterapp/Services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GymProgressionPage extends StatefulWidget {
  const GymProgressionPage({super.key});

  @override
  State<GymProgressionPage> createState() => _GymProgressionPageState();
}

class _GymProgressionPageState extends State<GymProgressionPage> {
  String? selectedOption; // Holds the currently selected dropdown value
  String? selectedSubOption;
  final TextEditingController hoursController =TextEditingController( );
  final TextEditingController minutesController = TextEditingController( );
  final TextEditingController weightController = TextEditingController();

  String resultText = ''; // Holds the result text to be displayed

  // List of core common activity types
  final List<String> dropdownOptions = [
    'Walking, Running, Cycling, Swimming',
    'Gym Activities',
    'Training and Sports',
    'Outdoor Activities',
    'Home Activities',
  ];
  
  // sub options contain activities for each activity type, activities selected on most common activities and sports
  final Map<String, List<String>> subOptions = {
    'Walking, Running, Cycling, Swimming':[
      'Walking: Slow',
      'Walking: Moderate',
      'Walking: Fast',
      'Hiking: Cross-Country',
      'Cycling: Slow',
      'Cycling: Moderate',
      'Cycling: Fast',
      'Cycling: Very Fast',
      'Cycling: BMX or Mountain Biking',
      'Swimming: Moderate',
      'Swimming: Laps or vigorously',
      'Running: Slow',
      'Running: Moderate',
      'Running: Fast',
      'Running: Cross-Country', 
    ],

    'Gym Activities':[
      'Aerobics Steps: High Impact',
      'Aerobics Steps: Low Impact',
      'Aerobics: High Impact',
      'Aerobics: Low Impact',
      'Aerobics: Water',
      'Cycling, Stationary: Moderate',
      'Cycling, Stationary: Vigorous',
      'Calisthenics: Moderate',
      'Calisthenics: Vigorous',
      'Elliptical Trainer: General',
      'Rowing, Stationary: Moderate',
      'Rowing, Stationary: Vigorous',
      'Stair Step Machine: General',
      'Weight Lifting: General',
      'Weight Lifting: Vigorous',
      'Circuit Training: General',    
      'Ski Machine: General',
      'Stretching Hatha Yoga'
    ],

    'Training and Sports':[
      'Badminton: General',
      'Basketball: Wheelchair',
      'Basketball: Playing a game',
      'Bowling',
      'Dancing: disco, ballroom, square',
      'Dancing: slow, waltz, foxtrot',
      'Dancing: Fast, ballet, twist',
      'Football: Competitive',
      'Football: touch, flag, general',
      'Frisbee',
      'Golf: Using Cart',
      'Golf: carrying clubs',
      'Handball: General',
      'Horseback Riding: General',
      'Kayaking',
      'Racquetball: casual, general'
      'Racquetball: competitive',
      'Rock Climbing: ascending',
      'Rock Climbing: rappelling',
      'Rollerblading/Skating: casual',
      'Rollerblading/Skating: fast',
      'Rope Jumping: Fast',
      'Rope Jumping: Slow',
      'Rugby: Competitive',
      'Skateboarding: General',
      'Skiing: Cross-Country',
      'Skiing: Downhill',
      'Snow Shoeing',
      'Softball: general play',
      'Tennis: General',
      'Volleyball: Competitive, gym play',
      'Volleyball: beach',
      'Volleyball: non-competitive',
      'Walk/Jog: jog < 10 min',
      'Water Skiing',
      'Whitewater: rafting, kayaking',
      'Billiards',
      'Boxing: sparring, punching bag',
      'Fencing: general',
      'Gymnastics: general',
      'Hockey: field and ice',
      'Ice Skating: general', 
      'Martial Arts: karate, judo, kickboxing',
      'Scuba Diving',
      'Sledding: luge, tobogganing',
      'Tai Chi',
      'Water Polo',
      'Wrestling',
    ],

    'Outdoor Activities':[
      'Carrying and stacking wood',
      'Fishing',
      'Mowing Lawn: Push, hand mower',
      'Mowing Lawn: Push, power mower',
      'Leaf/Snow Blower: Walking',
      'Shoveling Snow: by hand',
      'Chopping and splitting wood',
      'Gardening: general',
      'Raking Garden',
    ],

    'Home Activities':[
      'Cooking',
      'Heaving Cleaning: Washing car or windowes',
      'Moving: Furniture',
      'Moving: Boxes'
      'Playing with children: Moderate effort',
      'Standing in line',
      'Food Shopping: with cart',
      'Painting or remodeling',
      'Reading: Sitting',
      'Sleeping',
      'Watching TV',  
      ],

  };

  // MET values for each activity
  // MET (Metabolic Equivalent of Task) values for various activities - Data pulled from this public database https://pacompendium.com
  final Map<String, double> metValues = {
    'Walking: Slow': 2.8,
    'Walking: Moderate': 3.5,
    'Walking: Fast': 5.0,
    'Hiking: Cross-Country': 6.0,
    'Running: Slow': 8.3,
    'Running: Moderate': 9.8,
    'Running: Fast': 11.5,
    'Running: Cross-Country': 9.0,
    'Cycling: Slow': 6.0,
    'Cycling: Moderate': 8.0,
    'Cycling: Fast': 10.0,
    'Cycling: Very Fast': 12.0,
    'Cycling: BMX or Mountain Biking': 8.5,
    'Swimming: Moderate': 6.0,
    'Swimming: Laps or vigorously': 8.0,
    'Badminton: General': 4.5,
    'Basketball: Wheelchair': 4.5,
    'Basketball: Playing a game': 6.5,
    'Bowling': 3.0,
    'Dancing: disco, ballroom, square': 5.5,
    'Dancing: slow, waltz, foxtrot': 3.0,
    'Dancing: fast, ballet, twist': 7.0,
    'Football: Competitive': 8.0,
    'Football: Touch, Flag, General': 4.0,
    'Frisbee': 3.0,
    'Golf: Using Cart': 3.5,
    'Golf: Carrying Clubs': 4.8,
    'Handball: General': 12.0,
    'Horseback Riding: General': 5.5,
    'Kayaking': 5.0,
    'Racquetball: Casual, General': 7.0,
    'Racquetball: Competitive': 10.0,
    'Rock Climbing: Ascending': 8.0,
    'Rock Climbing: Rappelling': 7.0,
    'Rollerblading/Skating: Casual': 7.0,
    'Rollerblading/Skating: Fast': 12.0,
    'Rope Jumping: Fast': 12.0,
    'Rope Jumping: Slow': 8.8,
    'Rugby: Competitive': 10.0,
    'Skateboarding: General': 5.0,
    'Skiing: Cross-Country': 9.0,
    'Skiing: Downhill': 6.0,
    'Snow Shoeing': 8.0,
    'Softball: General Play': 5.0,
    'Tennis: General': 7.3,
    'Volleyball: Competitive, Gym Play': 8.0,
    'Volleyball: Beach': 8.0,
    'Volleyball: Non-Competitive': 3.0,
    'Walk/Jog: Jog < 10 min': 7.0,
    'Water Skiing': 6.0,
    'Whitewater: Rafting, Kayaking': 5.0,
    'Billiards': 2.5,
    'Boxing: Sparring, Punching Bag': 7.8,
    'Fencing: General': 6.0,
    'Gymnastics: General': 3.8,
    'Hockey: Field and Ice': 8.0,
    'Ice Skating: General': 7.0,
    'Martial Arts: Karate, Judo, Kickboxing': 10.3,
    'Scuba Diving': 7.0,
    'Sledding: Luge, Tobogganing': 7.0,
    'Tai Chi': 3.0,
    'Water Polo': 10.0,
    'Wrestling': 6.0,
    'Weight Lifting: General': 3.0,
    'Weight Lifting: Vigorous': 6.0,
    'Carrying and stacking wood': 5.5,
    'Fishing': 3.5,
    'Mowing Lawn: Push, hand mower': 6.0,
    'Mowing Lawn: Push, power mower': 5.0,
    'Leaf/Snow Blower: Walking': 3.0,
    'Shoveling Snow: by hand': 7.5,
    'Chopping and splitting wood': 6.0,
    'Gardening: general': 4.0,
    'Raking Garden': 4.0,
    'Cooking': 3.5,
    'Heaving Cleaning: Washing car or windows': 4.0,
    'Moving: Furniture': 5.8,
    'Moving: Boxes': 4.0,
    'Playing with children: Moderate effort': 4.0,
    'Standing in line': 1.8,
    'Food Shopping: with cart': 2.3,
    'Painting or remodeling': 4.5,
    'Reading: Sitting': 1.3,
    'Sleeping': 0.9,
    'Watching TV': 1.0,
  };

  @override
  Widget build(BuildContext context) {
     return ChangeNotifierProvider<CalorieCountProvider>(
          create: (_) => CalorieCountProvider()..loadTargetsAsync(),
          builder: (context, child) {
             final calorieProvider = Provider.of<CalorieCountProvider>(context, listen: false);
      return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Gym Calculator',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select an Activity Type:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedOption,
              hint: const Text('Choose an activity'),
              items: dropdownOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                  selectedSubOption = null; // Reset sub-option when main option changes    
                });
              },
            ),
            const SizedBox(height: 20),
            if (selectedOption != null && subOptions.containsKey(selectedOption)) ...[
              const Text(
                'Select a Sub-Activity:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedSubOption,
                
                hint: const Text('Choose a sub-activity'),
                items: subOptions[selectedOption!]?.map((String subOption) {
                  return DropdownMenuItem<String>(
                    value: subOption,
                    child: Text(subOption),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubOption = newValue;
                  });
                },
               menuMaxHeight: 300,
              ),
              const SizedBox(height: 20), 
            ],
            const Text (
              'Enter Duration and Body Weight:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: hoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Hours',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), 
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: minutesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Body Weight (kg)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),  
            ),
            const SizedBox(height: 20),

            Center(
  child: Row(
    

    children: [
      Padding(
        padding: const EdgeInsets.only(right: 70.0),
      child: IconButton(
        icon: const Icon(Icons.info, size: 40, color: Colors.blue),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("About the Calculation"),
                content: const Text(
                  'The calculator estimates the number of calories you burn while performing a specific activity for a duration of time and your weight.\n'
                  'The calculation uses MET (Metabolic Equivalent of Task) values for each activity to calculate calories burned.\n'
                  'This represents the energy cost of physical activities as a multiple of resting metabolic rate.\n\n'
                  'The formula used is: MET * weight (kg) * time (minutes) / 200.\n\n'
                  'This is an approximation and actual calories burned may vary based on individual factors.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              );
          
            },
          );
        },
      ),
      ),
      const SizedBox(width: 10), // Add spacing between the buttons
      ElevatedButton(
        onPressed: () {
          final hours = int.tryParse(hoursController.text) ?? 0;
          final minutes = int.tryParse(minutesController.text) ?? 0;
          final weight = int.tryParse(weightController.text) ?? 0;

          if (selectedSubOption == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select an activity type')),
            );
            return;
          }

          final met = metValues[selectedSubOption!] ?? 0.0;

          final totalMinutes = (hours * 60) + minutes;
          final burntCalorie = (met * weight * totalMinutes) / 200;

          

          int dailyTarget = calorieProvider.dailyTarget ?? 0;
          int weeklyTarget = calorieProvider.weeklyTarget ?? 0;
          double remainingDaily = ((calorieProvider.remainingCaloriesDaily ?? 0) + burntCalorie);
          double remainingWeekly = ((calorieProvider.remainingCaloriesWeekly ?? 0) + burntCalorie);
          double progressDaily = ((dailyTarget - remainingDaily) / dailyTarget).clamp(0.0, 1.0);
          double progressWeekly = ((weeklyTarget - remainingWeekly) / weeklyTarget).clamp(0.0, 1.0);

          print('Daily Target Gym: $dailyTarget');
          print('Weekly Target Gym: $weeklyTarget');


          if (burntCalorie > 0) {

            final calorieCount = CalorieCount(
            name: "Exercise", 
            calories: burntCalorie, 
            activityType: selectedOption, 
            subActivityType: selectedSubOption, 
            salt: 0, 
            sugar: 0, 
            protein: 0, 
            fat: 0, 
            satFat: 0, 
            month: DateTime.now().month, 
            date: DateTime.now().day, 
            dayOfWeek: DateFormat('EEEE').format(DateTime.now()), 
            weeklyTarget: weeklyTarget , 
            dailyTarget: dailyTarget, 
            calorieTotals: 0, 
            remainingCaloriesDaily: remainingDaily, 
            remainingCaloriesWeekly: remainingWeekly, 
            progressDaily: progressDaily, 
            progressWeekly: progressWeekly);
            
            final databaseService = DatabaseService();
            databaseService.saveCalorieCount(calorieCount);
          }

          if(burntCalorie > 0){
              setState((){
              resultText = 'You have burnt approximately ${burntCalorie.toStringAsFixed(2)} calories. Calories burned have been added to your calorie count.'; 
            });
          }
          else{
            setState((){
              resultText = 'Error: Invalid input. Please check values are entered.';
            });
          }
            
          
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        child: const Text(
          'Calculate',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      
    ],
  ),
),
            const SizedBox(height: 20),
            if(resultText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),    
                  ]
                  
                ),
                child: Text(
                resultText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              ),
          ],
        ),
      ),
        
        
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 0, 0, 0),
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
    );
  }
  );
  }
}