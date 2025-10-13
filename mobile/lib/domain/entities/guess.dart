class Guess {
  final String id;
  final int gameId;
  final String answer;
  final DateTime createdAt;

  const Guess({
    required this.id,
    required this.gameId,
    required this.answer,
    required this.createdAt,
  });

  Guess copyWith({String? answer}) => Guess(
        id: id,
        gameId: gameId,
        answer: answer ?? this.answer,
        createdAt: createdAt,
      );
}
