import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../domain/entities/guess.dart';
import '../../domain/repositories/game_repository.dart';
import '../viewmodels/history_view_model.dart';
import '../widgets/loading_error_view.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryViewModel(context.read<GameRepository>())..load(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: Consumer<HistoryViewModel>(
        builder: (context, vm, _) {
          return LoadingErrorView(
            loading: vm.loading,
            error: vm.error,
            onRetry: vm.load,
            child: vm.items.isEmpty
                ? Center(child: Text(l10n.noData))
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final item = vm.items[index];
                      return ListTile(
                        title: Text(item.answer),
                        subtitle: Text('#${item.gameId} • ${item.createdAt.toLocal()}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: l10n.edit,
                              onPressed: () => _edit(context, vm, item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: l10n.delete,
                              onPressed: () => vm.remove(item.id),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: vm.items.length,
                  ),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => _add(context),
          tooltip: l10n.add,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.read<HistoryViewModel>();
    final controller = TextEditingController();
    int gameId = 1;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.add),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: controller, decoration: InputDecoration(labelText: l10n.guessPrompt)),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Game ID'),
              onChanged: (v) => gameId = int.tryParse(v) ?? 1,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              await vm.add(gameId, controller.text);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, HistoryViewModel vm, Guess guess) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: guess.answer);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.edit),
        content: TextField(controller: controller, decoration: InputDecoration(labelText: l10n.guessPrompt)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              await vm.update(guess, controller.text);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
