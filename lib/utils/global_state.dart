import 'package:diet_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class GlobalState with ChangeNotifier {
  UserModel? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  UserModel? get user => _user;

  UserModel? get currentUser => _user;

  // Getter to check if a user is logged in
  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  GlobalState() {
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        _user = null;
      } else {
        // Assuming you have a method to convert Firebase User to your UserModel
        _user = await UserModel.fetchFromFirestoreGivenId(user.uid);
      }
      notifyListeners();
    });
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void updateUserInfo(UserModel? user) async {
    if (user == null) {
      _user = null;
    } else {
      // Assuming you have a method to convert Firebase User to your UserModel
      _user = await UserModel.fetchFromFirestoreGivenId(user.uid);
    }
    notifyListeners();
  }

  void setUser(UserModel? user) {
    updateUserInfo(user);
    notifyListeners();
  }

  void setCurrentUser(UserModel? user) {
    setUser(user);
    notifyListeners();
  }
}
