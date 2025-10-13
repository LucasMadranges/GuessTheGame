import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/di/di.dart';
import 'domain/repositories/game_repository.dart';
import 'presentation/router/app_router.dart';
import 'presentation/state/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();
    final router = createRouter(navigatorKey);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        Provider<GameRepository>(create: (_) => DI.provideGameRepository()),
      ],
      child: Builder(
        builder: (context) {
          final locale = context.watch<AppState>().locale;
          return MaterialApp.router(
            title: 'GuessTheGame',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
            routerConfig: router,
            locale: locale,
            supportedLocales: const [Locale('en'), Locale('fr')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}

