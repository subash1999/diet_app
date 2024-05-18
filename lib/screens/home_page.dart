import 'package:diet_app/services/meal_service.dart';
import 'package:flutter/material.dart';
import '../layout/app_layout.dart';
import '../models/user_model.dart';
import '../utils/global_state.dart';
import '../utils/utils.dart'; // Import the Utils class for the greeting message
import '../widgets/calorie_progress_indicator.dart';
import '../widgets/gradient_floating_action_button.dart';
import '../widgets/meal_logging_dialog.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // Placeholder for user's name, replace 'User' with the actual variable if available
  String userName = 'User';
  int todayIntake = 0;
  int totalCaloriesGoal = 2000;
  String totalCaloriesMessage = '';
  bool isTotalCaloriesAssumed = true;

  String greetingMessage = '';

  void updateState() async {
    // fetch today's intake of calories
    todayIntake = await MealService.searchTodayTotalCaloriesForCurrentUser();
    setState(() {
      UserModel? _user = context.read<GlobalState>().currentUser;
      userName =
          _user?.name ?? userName; // Fallback to "User" if _user.name is null
      greetingMessage = GreetingUtil.greetUserWithEmoji(userName, _user?.dob!);

      if (_user != null) {
        totalCaloriesGoal = _user.findDailyGoalCaloriesForUser();
      }

      if (_user?.currentWeight == null ||
          _user?.goalWeight == null ||
          _user?.daysToAchieveGoal == null) {
        totalCaloriesMessage =
            'This is assumed value. Please set your current weight goal weight and days to achieve goal in the profile page to see your daily calorie goal';
        isTotalCaloriesAssumed = true;
      } else {
        totalCaloriesMessage =
            'This is calculated by formula based on your current weight, goal weight and days to achieve goal';
        isTotalCaloriesAssumed = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
// Call updateState when the app is resumed and this page is potentially visible again
      updateState();
    }
  }

  void _showMealLoggingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MealLoggingDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppLayout(
        child: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Align to the top center
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  greetingMessage,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: CalorieProgressIndicator(
                  currentCalories: todayIntake,
                  totalCaloriesGoal: totalCaloriesGoal,
                  totalCaloriesMessage: totalCaloriesMessage,
                  isTotalCaloriesAssumed: isTotalCaloriesAssumed,
                ),
              ),
            ],
          )),
        ),
      ),
      floatingActionButton: GradientFloatingActionButton(
        onPressed: () {
          _showMealLoggingDialog(context);
        },
        icon: Icon(Icons.add, color: Colors.white),
        gradientColors: [Colors.purple, Colors.deepPurple],
      ),
    );
  }
}
