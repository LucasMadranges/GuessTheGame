import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'src/presentation/screens/home_page.dart';

void main() {
  runApp(const ForumApp());
}

class ForumApp extends StatefulWidget {
  const ForumApp({super.key});

  @override
  State<ForumApp> createState() => _ForumAppState();
}

class _ForumAppState extends State<ForumApp> {
  // Français par défaut
  Locale _locale = const Locale('fr');

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      // Force la locale courante (modifiable via le sélecteur)
      locale: _locale,
      // S'assure que si une résolution est tentée, on retombe bien sur la locale choisie
      localeResolutionCallback: (deviceLocale, supportedLocales) => _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomePage(onLocaleChange: _setLocale),
    );
  }
}
