import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../screens/play_screen.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../state/app_state.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const play = '/play';
  static const history = '/history';
  static const settings = '/settings';
}

GoRouter createRouter(GlobalKey<NavigatorState> key) {
  return GoRouter(
    navigatorKey: key,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'play',
            name: 'play',
            builder: (context, state) => PlayScreen(gameId: int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 0),
          ),
          GoRoute(
            path: 'history',
            name: 'history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final appState = context.read<AppState>();
      final onboarded = appState.onboarded;
      final goingToSplash = state.matchedLocation == AppRoutes.splash;
      if (!onboarded && !goingToSplash) {
        return AppRoutes.splash;
      }
      if (onboarded && goingToSplash) {
        return AppRoutes.home;
      }
      return null;
    },
  );
}
