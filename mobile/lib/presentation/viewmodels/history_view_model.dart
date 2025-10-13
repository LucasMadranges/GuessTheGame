import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/guess.dart';
import '../../domain/repositories/game_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  final GameRepository _repo;
  HistoryViewModel(this._repo);

  List<Guess> items = [];
  bool loading = false;
  Object? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      items = await _repo.getGuesses();
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> add(int gameId, String answer) async {
    final id = const Uuid().v4();
    final guess = Guess(id: id, gameId: gameId, answer: answer, createdAt: DateTime.now());
    await _repo.addGuess(guess);
    await load();
  }

  Future<void> update(Guess guess, String answer) async {
    await _repo.updateGuess(guess.copyWith(answer: answer));
    await load();
  }

  Future<void> remove(String id) async {
    await _repo.deleteGuess(id);
    await load();
  }
}
