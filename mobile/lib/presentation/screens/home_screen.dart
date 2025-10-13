import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../core/di/di.dart';
import '../../domain/entities/game.dart';
import '../../domain/repositories/game_repository.dart';
import '../router/app_router.dart';
import '../viewmodels/home_view_model.dart';
import '../widgets/loading_error_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<HomeViewModel>(
      create: (_) => HomeViewModel(context.read<GameRepository>())..load(),
      child: const _HomeView(),
      dispose: (_, vm) => vm.dispose(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go('${AppRoutes.home}/history'),
            tooltip: l10n.historyTitle,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('${AppRoutes.home}/settings'),
            tooltip: l10n.settingsTitle,
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          return LoadingErrorView(
            loading: vm.loading,
            error: vm.error,
            onRetry: vm.load,
            child: vm.games.isEmpty
                ? Center(child: Text(l10n.noData))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 600;
                      final crossAxisCount = isWide ? 3 : 1;
                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: isWide ? 3 : 2.5,
                        ),
                        itemCount: vm.games.length,
                        itemBuilder: (context, index) {
                          final game = vm.games[index];
                          return _GameCard(game: game);
                        },
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final Game game;
  const _GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final location = '${AppRoutes.home}/play?id=${game.id}';
          context.go(location);
        },
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(game.imageUrls.first, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(game.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text('${l10n.playTitle} • ${game.date.toLocal().toIso8601String().substring(0, 10)}'),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
