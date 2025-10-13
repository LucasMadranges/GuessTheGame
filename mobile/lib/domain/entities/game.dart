class Game {
  final int id;
  final String title;
  final List<String> imageUrls; // 6 images, from hardest to easiest
  final DateTime date; // the day the game is for

  const Game({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.date,
  });
}
