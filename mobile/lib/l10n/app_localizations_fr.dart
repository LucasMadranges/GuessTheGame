// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'GuessTheGame';

  @override
  String get homeTitle => 'Jeux du jour';

  @override
  String get playTitle => 'Jouer';

  @override
  String get historyTitle => 'Historique';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Une erreur est survenue';

  @override
  String get retry => 'Réessayer';

  @override
  String get guessPrompt => 'Votre réponse';

  @override
  String get validate => 'Valider';

  @override
  String get skip => 'Passer';

  @override
  String get congrats => 'Bravo ! Vous avez trouvé.';

  @override
  String get tryAgain => 'Pas tout à fait. Réessayez !';

  @override
  String get youLose => 'Perdu !';

  @override
  String get language => 'Langue';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get gamesOfDay => 'Jeux par jour';

  @override
  String get noData => 'Aucune donnée';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get add => 'Ajouter';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get onboardingTitle => 'Bienvenue';

  @override
  String get onboardingMessage =>
      'Bienvenue dans GuessTheGame. Appuyez sur continuer pour démarrer.';

  @override
  String get next => 'Continuer';
}
