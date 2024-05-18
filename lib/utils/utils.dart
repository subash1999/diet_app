import '../services/meal_service.dart';
import 'package:intl/intl.dart' as intl;

class GreetingUtil {
  static String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  static String getSunTimeEmoji() {
    int hour = DateTime.now().hour;
    if (hour < 6) {
      return '🌑'; // Night
    } else if (hour < 12) {
      return '🌅'; // Morning
    } else if (hour < 18) {
      return '🌞'; // Noon/Afternoon
    } else {
      return '🌇'; // Evening
    }
  }

  static String greetUserWithEmoji(String name, String? dob) {
    if (dob != null && Utils.todayDate() == dob) {
      return 'Happy Birthday $name 🎂';
    }
    String greeting = getGreeting();
    String sunTimeEmoji = getSunTimeEmoji();
    return '$greeting $name $sunTimeEmoji';
  }
}

class Utils {
  static String dateFormat(DateTime date) {
    return intl.DateFormat('yyyy-MM-dd').format(date);
  }

  static String currentDateTime() {
    return intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  static String todayDate() {
    return intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static bool isDateEqualToday(String date) {
    // change string to date and then compate with DateTime.now()
    return DateTime.parse(date).isAtSameMomentAs(DateTime.now());
  }

  static String getMealTypeByTime() {
    final hour = DateTime.now().hour;
    if (hour < 10) {
      return 'Breakfast';
    } else if (hour < 14) {
      return 'Lunch';
    } else if (hour < 17) {
      return 'Snack';
    } else {
      return 'Dinner';
    }
  }

  static String getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return '🍳';
      case 'Lunch':
        return '🍔';
      case 'Dinner':
        return '🍝';
      case 'Snack':
        return '🍪';
      default:
        return '🍽️';
    }
  }

  static String getMealTypeBasedOnTime() {
    final hour = DateTime.now().hour;
    if (hour < 10) {
      return 'Breakfast';
    } else if (hour < 14) {
      return 'Lunch';
    } else if (hour < 17) {
      return 'Snack';
    } else {
      return 'Dinner';
    }
  }

  static int calculateAge(String dob) {
    try {
      DateTime birthDate = DateTime.parse(dob);
      DateTime currentDate = DateTime.now();

      int age = currentDate.year - birthDate.year;

      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      return -1;
    }
  }
}

class CalorieCalculator {
  static double calculateDailyCalories(
      {required int age,
      required int height, // in cm
      required double weight, // in kg
      required String gender,
      ActivityLevel activityLevel = ActivityLevel.sedentary}) {
    double bmr;

    if (gender.toLowerCase() == "male") {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }

    double activityFactor = getActivityFactor(activityLevel);
    return bmr * activityFactor;
  }

  static double getActivityFactor(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extraActive:
        return 1.9;
      default:
        return 1.2;
    }
  }

  static int calorieToCutPerDay(
      double? currentWeight, double? goalWeight, int? daysToAchieveGoal) {
    // calculate the total calories
    try {
      if (currentWeight != null &&
          goalWeight != null &&
          daysToAchieveGoal != null &&
          daysToAchieveGoal != 0 &&
          currentWeight != 0 &&
          goalWeight != 0) {
        int totalCalories = 0;
        // 7700 is the calorie equivalent of 1 kg of body weight
        totalCalories =
            (currentWeight - goalWeight) * 7700 ~/ daysToAchieveGoal;
        return totalCalories;
      }
    } catch (e) {
      return -1;
    }
    return -1;
  }
}

enum ActivityLevel {
  sedentary, // little or no exercise
  lightlyActive, // light exercise/sports 1-3 days a week
  moderatelyActive, // moderate exercise/sports 3-5 days a week
  veryActive, // hard exercise/sports 6-7 days a week
  extraActive, // very hard exercise/sports & physical job or 2x training
}
