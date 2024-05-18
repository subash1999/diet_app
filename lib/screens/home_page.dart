import 'package:diet_app/services/meal_service.dart';
import 'package:diet_app/widgets/home_page_date_changer.dart';
import 'package:diet_app/widgets/meals_table.dart';
import 'package:flutter/material.dart';
import '../layout/app_layout.dart';
import '../models/meal_model.dart';
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

  List<MealModel> mealModelList = [];

  DateTime dashboardDate = DateTime.now();

  String date = Utils.todayDate();

  void updateState() async {
    dashboardDate = context.read<GlobalState>().dashboardDate;
    date = Utils.dateFormat(dashboardDate);

    // fetch today's intake of calories
    todayIntake =
        await MealService.searchTotalCaloriesForCurrentUserForDate(date);
    List<MealModel> meals =
        await MealService.searchMealsOfCurrentUserForDate(date);

    setState(() {
      dashboardDate = context.read<GlobalState>().dashboardDate;
      date = Utils.dateFormat(dashboardDate);

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

      // meals table
      mealModelList = meals;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Listen to the global state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GlobalState>(context, listen: false).addListener(updateState);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Listen to the global state changes
      Provider.of<GlobalState>(context, listen: false).addListener(() {
        // Fetch the new dashboardDate from GlobalState
        DateTime newDashboardDate =
            Provider.of<GlobalState>(context, listen: false).dashboardDate;
        // Check if the dashboardDate has changed
        if (newDashboardDate != dashboardDate) {
          setState(() {
            // Update the dashboardDate with the new value
            dashboardDate = newDashboardDate;
            // Update any other state that depends on the dashboardDate
            date = Utils.dateFormat(dashboardDate);
          });
        }
      });
    });

    dashboardDate = context.read<GlobalState>().dashboardDate;
    date = Utils.dateFormat(dashboardDate);

    updateState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Provider.of<GlobalState>(context, listen: false)
        .removeListener(updateState);
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
        return MealLoggingDialog(selectedDate: dashboardDate);
      },
    ).then((_) {
      context.read<GlobalState>().updateHomePageState(true);
    });
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
              HomePageDateChanger(initialDate: dashboardDate),
              Padding(
                padding: const EdgeInsets.all(20),
                child: CalorieProgressIndicator(
                  currentCalories: todayIntake,
                  totalCaloriesGoal: totalCaloriesGoal,
                  totalCaloriesMessage: totalCaloriesMessage,
                  isTotalCaloriesAssumed: isTotalCaloriesAssumed,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Meals ${date}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              MealsTable(meals: mealModelList),
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
