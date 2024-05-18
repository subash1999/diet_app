import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/hash_util.dart';

class UserModel {
  String uid;
  String name;
  String dob;
  String email;
  String? gender;
  double? height;
  String? heightUnit;
  String? passwordResetOtp;
  int? daysToAchieveGoal;
  double? currentWeight;
  double? goalWeight;
  String? weightUnit;

  static final String _collection = 'users';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel({
    required this.uid,
    required this.name,
    required this.dob,
    required this.gender,
    required this.email,
    this.height,
    this.heightUnit,
    this.passwordResetOtp,
    this.currentWeight,
    this.goalWeight,
    this.weightUnit,
    this.daysToAchieveGoal,
  });

  // Convert a UserModel into a JSON object
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'dob': dob,
      'email': email,
      'gender': gender,
      'height': height,
      'passwordResetOtp': passwordResetOtp,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'WeightUnit': weightUnit,
      'daysToAchieveGoal': daysToAchieveGoal,
    };
  }

  // Factory constructor to create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      dob: map['dob'],
      gender: map['gender'],
      email: map['email'],
      height: map['height'],
      passwordResetOtp: map['passwordResetOtp'],
      daysToAchieveGoal: map['daysToAchieveGoal'],
      currentWeight: map['currentWeight'],
      goalWeight: map['goalWeight'],
      weightUnit: map['WeightUnit'],
    );
  }

  static Future<UserModel?> fetchFromFirestoreGivenId(String uid) async {
    DocumentSnapshot doc =
        await _firestore.collection(_collection).doc(uid).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return UserModel.fromMap(data);
    }
    return null;
  }

  Future<void> addToFirestore() async {
    await _firestore.collection(_collection).doc(uid).set(toMap());
  }

  Future<UserModel?> fetchFromFirestore() async {
    DocumentSnapshot doc =
        await _firestore.collection(_collection).doc(uid).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return UserModel.fromMap(data);
    }
    return null;
  }

  Future<void> updateInFirestore() async {
    await _firestore.collection(_collection).doc(uid).update(toMap());
  }

  Future<void> deleteFromFirestore() async {
    await _firestore.collection(_collection).doc(uid).delete();
  }

  Future<void> searchUserByEmail(String email) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(_collection)
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('User not found');
    }
  }

  static Future<UserModel> searchUserByNameDobEmail(
      String name, String dob, String email) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(_collection)
        .where('name', isEqualTo: name)
        .where('dob', isEqualTo: dob)
        .where('email', isEqualTo: email)
        .get();
    String? userId;
    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the first document's data
      Map<String, dynamic> userData =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      // Extract the user ID from the document
      userId = userData['uid'];
    }
    if (userId == null) {
      throw Exception('User not found');
    }
    UserModel? userModel = await UserModel.fetchFromFirestoreGivenId(userId)!;
    if (userModel == null) {
      throw Exception('User not found');
    }
    return userModel;
  }

  int findDailyGoalCaloriesForUser() {
    if (dob == null || height == null || currentWeight == null) {
      return -1;
    }
    int age = Utils.calculateAge(dob);
    if (age == -1) {
      age = 30;
    }
    double weight = currentWeight ?? 0.0; // Assuming currentWeight is a double
    String gender = this.gender ?? "unknown"; // Handling potential null gender
    int heightInCm = height?.toInt() ?? 0;

    int normalCalorieRequired = CalorieCalculator.calculateDailyCalories(
            age: age, height: heightInCm, weight: weight, gender: gender)
        .toInt();
    int calorieCutForWeightLoss = 0;
    if (goalWeight != null &&
        daysToAchieveGoal != null &&
        currentWeight != 0 &&
        goalWeight != 0 &&
        daysToAchieveGoal != 0) {
      calorieCutForWeightLoss = CalorieCalculator.calorieToCutPerDay(
          currentWeight, goalWeight, daysToAchieveGoal);
    }

    return normalCalorieRequired - calorieCutForWeightLoss;
  }
}
