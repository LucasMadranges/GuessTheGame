import 'package:flutter/foundation.dart';

import '../../domain/entities/game.dart';
import '../../domain/repositories/game_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final GameRepository _repo;
  HomeViewModel(this._repo);

  List<Game> games = [];
  bool loading = false;
  Object? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      games = await _repo.fetchGames();
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
