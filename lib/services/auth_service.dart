import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _currentUser;

  Future<UserModel> registerUser(String name, String dob, String gender,
      String email, String password) async {
    UserCredential? userCredential;
    try {
      // Create user with email and password
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a new user model instance
      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        dob: dob,
        email: email,
        gender: gender,
      );

      // Add the new user to Firestore
      await newUser.addToFirestore();

      // return the registered user model
      return newUser;
    } catch (e) {
      // Step 3: If Firestore operation fails, delete the Firebase Auth user
      if (userCredential != null && userCredential.user != null) {
        await userCredential.user!.delete();
      }
      rethrow;
    }
  }

  Future<UserModel> signUp(String name, String dob, String gender, String email,
      String password) async {
    return await registerUser(name, dob, gender, email, password);
  }

  Future<UserModel> loginUser(String email, String password) async {
    try {
      // Sign in the user with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // get the user's document from Firestore
      UserModel? user =
          await UserModel.fetchFromFirestoreGivenId(_auth.currentUser!.uid);
      if (user == null) {
        throw Exception('Invalid Credentials');
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  Future<void> signOut() async {
    await logoutUser();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // check if user with name, dob, and email exists
  Future<UserModel?> checkUserExistsByNameDobEmail(
      String name, String dob, String email) async {
    try {
      UserModel user =
          await UserModel.searchUserByNameDobEmail(name, dob, email);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        UserModel? userModel =
            await UserModel.fetchFromFirestoreGivenId(firebaseUser.uid);
        if (userModel != null) {
          _currentUser =
              userModel; // Update the _currentUser variable with the latest user data
        } else {
          _currentUser =
              null; // Set _currentUser to null if the user data could not be fetched
        }
      } else {
        _currentUser =
            null; // Set _currentUser to null if there's no current Firebase user
      }
    } catch (e) {
      _currentUser = null; // Ensure _currentUser is null on error
      rethrow;
    }
    return _currentUser;
  }

  // Update user profile
  Future<void> updateUser(UserModel user) async {
    await user.updateInFirestore();
  }
}
