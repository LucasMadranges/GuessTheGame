import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../state/app_state.dart';
import '../viewmodels/settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(context.read<AppState>()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SettingsViewModel>(
          builder: (context, vm, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                DropdownButton<Locale>(
                  value: vm.locale,
                  items: const [
                    DropdownMenuItem(value: Locale('en'), child: Text('English')),
                    DropdownMenuItem(value: Locale('fr'), child: Text('Français')),
                  ],
                  onChanged: (val) {
                    if (val != null) vm.changeLocale(val);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
