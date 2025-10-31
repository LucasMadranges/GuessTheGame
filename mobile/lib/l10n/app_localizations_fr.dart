// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Forum Mobile';

  @override
  String get forumApp => 'Forum App';

  @override
  String get navMessages => 'Messages';

  @override
  String get navSend => 'Envoyer';

  @override
  String get navBlog => 'Blog';

  @override
  String get loading => 'Chargement...';

  @override
  String get retry => 'Réessayer';

  @override
  String get messagesLoadErrorTitle => 'Erreur lors du chargement des messages';

  @override
  String get noMessage => 'Aucun message';

  @override
  String get search => 'Recherche';

  @override
  String get filterByAuthor => 'Filtrer par auteur';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get author => 'Auteur';

  @override
  String get message => 'Message';

  @override
  String get sending => 'Envoi en cours...';

  @override
  String get send => 'Envoyer';

  @override
  String get messageSent => 'Message envoyé';

  @override
  String get sendTip => 'Astuce: une erreur d\'envoi est simulée aléatoirement pour tester la gestion des erreurs. Réessayez si nécessaire.';

  @override
  String get errorRequiredFields => 'Auteur et message requis';

  @override
  String get blogLoadErrorTitle => 'Erreur lors du chargement du blog';

  @override
  String get noArticle => 'Aucun article';

  @override
  String get refresh => 'Rafraîchir';

  @override
  String get language => 'Langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageFrench => 'Français';
}
