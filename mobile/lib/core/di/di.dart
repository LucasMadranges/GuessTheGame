import 'package:http/http.dart' as http;

import '../../data/repositories/game_repository_impl.dart';
import '../../domain/repositories/game_repository.dart';

class DI {
  static GameRepository provideGameRepository() => GameRepositoryImpl(client: http.Client());
}
