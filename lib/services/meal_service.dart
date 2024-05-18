import 'package:diet_app/utils/utils.dart';
import 'package:flutter/material.dart';

import '../models/meal_model.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealService {
  static Future<List<MealModel>> searchTodayMeals() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // get the current date
    String todayDate = Utils.todayDate();
    // search for meals of the current date
    return await MealModel.searchMealsOfDayForUser(
        _auth.currentUser!.uid, todayDate);
  }

  // find today's total calories
  static Future<int> searchTodayTotalCaloriesForCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // get the current date
    String todayDate = Utils.todayDate();
    // search for meals of the current date
    List<MealModel> meals = await MealModel.searchMealsOfDayForUser(
        _auth.currentUser!.uid, todayDate);
    // calculate the total calories
    int totalCalories = 0;
    meals.forEach((meal) {
      totalCalories += meal.calories;
    });
    return totalCalories;
  }

  static Future deleteMeal(MealModel meal) async {
    if (meal.id != null) {
      await MealModel.deleteFromFirestore(meal.id as String);
    } else {
      throw Exception('Meal not found');
    }
  }

  static Future<List<MealModel>> searchMealsOfCurrentUserForDate(
      String date) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return await MealModel.searchMealsOfDayForUser(
        _auth.currentUser!.uid, date);
  }

  static Future<List<MealModel>> searchMealsForUser(String uid) async {
    return await MealModel.fetchMealsForUser(uid);
  }

  static Future<void> deleteMealsForUser(String uid) async {
    await MealModel.deleteMealsForUser(uid);
  }

  static Future<void> deleteMealsForUserAndDate(String uid, String date) async {
    List<MealModel> meals = await MealModel.searchMealsOfDayForUser(uid, date);
    meals.forEach((meal) async {
      await MealModel.deleteFromFirestore(meal.id as String);
    });
  }
}

class DateFormat {}
