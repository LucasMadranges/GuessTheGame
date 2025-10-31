// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Forum Mobile';

  @override
  String get forumApp => 'Forum App';

  @override
  String get navMessages => 'Messages';

  @override
  String get navSend => 'Send';

  @override
  String get navBlog => 'Blog';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get messagesLoadErrorTitle => 'Error loading messages';

  @override
  String get noMessage => 'No message';

  @override
  String get search => 'Search';

  @override
  String get filterByAuthor => 'Filter by author';

  @override
  String get reset => 'Reset';

  @override
  String get author => 'Author';

  @override
  String get message => 'Message';

  @override
  String get sending => 'Sending...';

  @override
  String get send => 'Send';

  @override
  String get messageSent => 'Message sent';

  @override
  String get sendTip => 'Tip: a send error is randomly simulated to test error handling. Try again if necessary.';

  @override
  String get errorRequiredFields => 'Author and message are required';

  @override
  String get blogLoadErrorTitle => 'Error loading blog';

  @override
  String get noArticle => 'No article';

  @override
  String get refresh => 'Refresh';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'French';
}
