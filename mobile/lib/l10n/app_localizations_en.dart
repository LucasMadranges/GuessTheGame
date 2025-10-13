// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GuessTheGame';

  @override
  String get homeTitle => 'Daily Games';

  @override
  String get playTitle => 'Play';

  @override
  String get historyTitle => 'History';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get aboutTitle => 'About';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get guessPrompt => 'Your guess';

  @override
  String get validate => 'Validate';

  @override
  String get skip => 'Skip';

  @override
  String get congrats => 'Congratulations! You found it.';

  @override
  String get tryAgain => 'Not quite. Try again!';

  @override
  String get youLose => 'You lose!';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get gamesOfDay => 'Games by day';

  @override
  String get noData => 'No data';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get onboardingTitle => 'Welcome';

  @override
  String get onboardingMessage =>
      'Welcome to GuessTheGame. Tap continue to start.';

  @override
  String get next => 'Continue';
}
