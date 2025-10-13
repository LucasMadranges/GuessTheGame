import 'package:flutter/material.dart';

import '../state/app_state.dart';

class SettingsViewModel extends ChangeNotifier {
  final AppState _appState;
  SettingsViewModel(this._appState);

  Locale get locale => _appState.locale;

  void changeLocale(Locale locale) {
    _appState.setLocale(locale);
    notifyListeners();
  }
}
