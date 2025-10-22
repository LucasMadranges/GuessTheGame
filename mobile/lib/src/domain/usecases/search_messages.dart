import '../entities/message.dart';

class SearchMessages {
  List<Message> call(List<Message> all, {String query = '', String? author}) {
    final q = query.trim().toLowerCase();
    return all.where((m) {
      final matchesQuery = q.isEmpty || m.content.toLowerCase().contains(q) || m.author.toLowerCase().contains(q);
      final matchesAuthor = author == null || author.isEmpty || m.author.toLowerCase() == author.toLowerCase();
      return matchesQuery && matchesAuthor;
    }).toList();
  }
}
