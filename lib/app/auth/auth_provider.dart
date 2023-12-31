import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool _hasPermission = true;

  bool get isLoggedIn => _isLoggedIn;

  bool get hasPermission => _hasPermission;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void setPermission(bool value) {
    _hasPermission = value;
    notifyListeners();
  }
}
