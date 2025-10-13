import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../router/app_router.dart';
import '../state/app_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.onboardingTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(l10n.onboardingMessage, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<AppState>().completeOnboarding();
                  context.go(AppRoutes.home);
                },
                child: Text(l10n.next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
