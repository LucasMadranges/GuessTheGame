import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../domain/repositories/game_repository.dart';
import '../viewmodels/play_view_model.dart';
import '../widgets/loading_error_view.dart';

class PlayScreen extends StatelessWidget {
  final int gameId;
  const PlayScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayViewModel(context.read<GameRepository>(), gameId)..init(),
      child: const _PlayView(),
    );
  }
}

class _PlayView extends StatelessWidget {
  const _PlayView();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.playTitle)),
      body: Consumer<PlayViewModel>(
        builder: (context, vm, _) {
          return LoadingErrorView(
            loading: vm.loading,
            error: vm.error,
            onRetry: vm.init,
            child: vm.game == null
                ? Center(child: Text(l10n.noData))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final imageUrl = vm.game!.imageUrls[vm.step];
                      final isWide = constraints.maxWidth > 700;
                      final image = Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        ),
                      );
                      final controls = Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.guessPrompt),
                              const SizedBox(height: 8),
                              DropdownButton<String>(
                                value: vm.selectedAnswer.isEmpty ? null : vm.selectedAnswer,
                                hint: Text(l10n.guessPrompt),
                                items: vm.answerOptions
                                    .map((a) => DropdownMenuItem<String>(value: a, child: Text(a, maxLines: 1, overflow: TextOverflow.ellipsis)))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    vm.selectedAnswer = val;
                                    vm.notifyListeners();
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ElevatedButton(onPressed: vm.validate, child: Text(l10n.validate)),
                                  const SizedBox(width: 12),
                                  OutlinedButton(onPressed: vm.skip, child: Text(l10n.skip)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (vm.lastResult != null)
                                Text(
                                  vm.lastResult == true
                                      ? l10n.congrats
                                      : vm.step >= (vm.game!.imageUrls.length - 1)
                                          ? l10n.youLose
                                          : l10n.tryAgain,
                                  style: TextStyle(color: vm.lastResult == true ? Colors.green : Colors.red),
                                ),
                            ],
                          ),
                        ),
                      );

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isWide
                            ? Row(children: [image, const SizedBox(width: 16), controls])
                            : Column(children: [image, const SizedBox(height: 16), controls]),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
