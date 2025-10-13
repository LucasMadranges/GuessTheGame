import 'dart:math';

import 'package:http/http.dart' as http;

import '../../domain/entities/game.dart';
import '../../domain/entities/guess.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/remote_api.dart';

class GameRepositoryImpl implements GameRepository {
  final RemoteApi _api;
  final List<Guess> _guesses = [];

  GameRepositoryImpl({http.Client? client}) : _api = RemoteApi(client ?? http.Client());

  @override
  Future<List<Game>> fetchGames() async {
    final raws = await _api.fetchRawGames();
    final now = DateTime.now();
    // Group photos by albumId to simulate days; take 6 images per 'game'
    final games = <Game>[];
    for (int i = 0; i < raws.length; i += 6) {
      final slice = raws.sublist(i, (i + 6).clamp(0, raws.length));
      if (slice.isEmpty) continue;
      final id = slice.first['albumId'] as int? ?? slice.first['id'] as int? ?? i;
      final title = slice.first['title'] as String? ?? 'Game $i';
      final images = slice.map((e) => e['url'] as String? ?? e['thumbnailUrl'] as String? ?? '').where((u) => u.isNotEmpty).toList();
      if (images.length < 3) continue;
      games.add(Game(
        id: id,
        title: title,
        imageUrls: images.take(6).toList(),
        date: now.subtract(Duration(days: max(0, games.length))),
      ));
    }
    return games;
  }

  @override
  Future<Game> fetchGameOfDay() async {
    final all = await fetchGames();
    if (all.isEmpty) {
      throw Exception('No games');
    }
    final index = DateTime.now().difference(DateTime(2024, 1, 1)).inDays % all.length;
    return all[index];
  }

  @override
  Future<bool> submitGuess({required int gameId, required String answer}) async {
    // Simple mock: consider correct if answer contains any word of title (case-insensitive) for the game of the day
    final games = await fetchGames();
    final game = games.firstWhere((g) => g.id == gameId, orElse: () => games.first);
    final ok = game.title.toLowerCase().split(' ').any((part) => part.isNotEmpty && answer.toLowerCase().contains(part));
    return ok;
  }

  @override
  Future<Guess> addGuess(Guess guess) async {
    _guesses.add(guess);
    return guess;
  }

  @override
  Future<void> deleteGuess(String id) async {
    _guesses.removeWhere((g) => g.id == id);
  }

  @override
  Future<List<Guess>> getGuesses() async => List.unmodifiable(_guesses);

  @override
  Future<Guess> updateGuess(Guess guess) async {
    final idx = _guesses.indexWhere((g) => g.id == guess.id);
    if (idx >= 0) {
      _guesses[idx] = guess;
    }
    return guess;
  }
}
