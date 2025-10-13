import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _onboarded = false;
  Locale _locale = const Locale('en');

  bool get onboarded => _onboarded;
  Locale get locale => _locale;

  void completeOnboarding() {
    _onboarded = true;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
