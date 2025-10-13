import '../entities/game.dart';
import '../entities/guess.dart';

abstract class GameRepository {
  Future<List<Game>> fetchGames();
  Future<Game> fetchGameOfDay();
  Future<bool> submitGuess({required int gameId, required String answer});

  // simple in-memory CRUD for Guess history
  Future<List<Guess>> getGuesses();
  Future<Guess> addGuess(Guess guess);
  Future<Guess> updateGuess(Guess guess);
  Future<void> deleteGuess(String id);
}
