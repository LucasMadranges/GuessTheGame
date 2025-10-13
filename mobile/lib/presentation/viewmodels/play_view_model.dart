import 'package:flutter/foundation.dart';

import '../../domain/entities/game.dart';
import '../../domain/repositories/game_repository.dart';

class PlayViewModel extends ChangeNotifier {
  final GameRepository _repo;
  final int gameId;
  PlayViewModel(this._repo, this.gameId);

  Game? game;
  bool loading = false;
  Object? error;
  int step = 0; // from 0 to max images - 1
  String selectedAnswer = '';
  bool? lastResult; // true if win, false if lose

  List<String> answerOptions = [];

  Future<void> init() async {
    loading = true;
    notifyListeners();
    try {
      final games = await _repo.fetchGames();
      game = games.firstWhere((g) => g.id == gameId, orElse: () => games.first);
      // Simple options: take titles of first 10 games
      answerOptions = games.take(10).map((g) => g.title).toList();
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void skip() {
    if (game == null) return;
    if (step < (game!.imageUrls.length - 1)) {
      step++;
      notifyListeners();
    } else {
      lastResult = false;
      notifyListeners();
    }
  }

  Future<void> validate() async {
    if (game == null || selectedAnswer.isEmpty) return;
    final ok = await _repo.submitGuess(gameId: game!.id, answer: selectedAnswer);
    lastResult = ok;
    notifyListeners();
  }
}
