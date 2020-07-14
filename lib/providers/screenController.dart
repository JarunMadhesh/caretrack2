import 'package:flutter/material.dart';


class SymptomsScreenController with ChangeNotifier {
  bool _isLoading = false;

  void setTrue() {
    _isLoading = true;
    notifyListeners();
  }

  void setFalse() {
    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading {
    return _isLoading;
  }
}

class NewProfileScreenController with ChangeNotifier {
  bool _isLoading = false;

  void setTrue() {
    _isLoading = true;
    notifyListeners();
  }

  void setFalse() {
    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading {
    return _isLoading;
  }
}

class ScreenController with ChangeNotifier {
  bool _isLoading = false;

  void setTrue() {
    _isLoading = true;
    notifyListeners();
  }

  void setFalse() {
    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading {
    return _isLoading;
  }
}