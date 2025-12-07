import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchaseproject/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isLoggedIn = false;
  bool isInitialized = false; 
  User? user;

  // Login data store
  Future<void> _saveLogin(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', user.uid);
    await prefs.setString('email', user.email ?? '');
    isLoggedIn = true;
  }

 //Check the login
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      user = FirebaseAuth.instance.currentUser;
    }

    isInitialized = true;
    notifyListeners();
  }

  // Regstration 
  Future<bool> registerUser(String email, String password) async {
    isLoading = true;
    notifyListeners();

    user = await _authService.register(email, password);

    if (user != null) {
      await _saveLogin(user!);
    }

    isLoading = false;
    notifyListeners();
    return user != null;
  }

  //Login
  Future<bool> loginUser(String email, String password) async {
    isLoading = true;
    notifyListeners();

    user = await _authService.login(email, password);

    if (user != null) {
      await _saveLogin(user!);
    }

    isLoading = false;
    notifyListeners();
    return user != null;
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    user = null;
    isLoggedIn = false;
    notifyListeners();
  }
}
