import '../../domain/entities/message.dart';
import '../../domain/repositories/forum_repository.dart';
import '../remote/base_url.dart';
import '../remote/items_api.dart';

class ForumRepositoryImpl implements ForumRepository {
  final ItemsApi _api;

  ForumRepositoryImpl({ItemsApi? api})
    : _api = api ?? ItemsApi(baseUrl: defaultBaseUrl());

  @override
  Future<List<Message>> getMessages() async {
    final items = await _api.listItems();
    return items.map(_toMessage).toList();
  }

  @override
  Future<Message> addMessage(Message message) async {
    // Adapter le mapping selon votre entité Message.
    // Ici, on envoie le contenu dans `name` et, si présent, un détail dans `description`.
    final created = await _api.createItem(
      name: _messagePrimaryText(message),
      description: _messageSecondaryText(message),
    );
    return _toMessage(created);
  }

  @override
  Future<List<Message>> searchMessages(String query) async {
    final q = query.toLowerCase();
    final all = await getMessages();
    return all
        .where((m) => _messagePrimaryText(m).toLowerCase().contains(q))
        .toList();
  }

  // Mapping ItemDto -> Message
  Message _toMessage(ItemDto i) {
    try {
      return Message(
        id: i.id.toString(),
        content: i.description.isNotEmpty ? i.description : '',
        author: i.name,
        createdAt: i.updatedAt.toUtc(),
      );
    } catch (_) {
      // Fallback générique si le constructeur diffère: créer via `Message.fromJson` si disponible.
      if (Message is Function) {
        // ignore: avoid_dynamic_calls
        return (Message as dynamic).fromJson({
              'id': i.id,
              'content': i.description.isNotEmpty ? i.description : i.name,
              'updatedAt': i.updatedAt.toIso8601String(),
            })
            as Message;
      }
      rethrow;
    }
  }

  // Texte principal d'un message pour la recherche / création
  String _messagePrimaryText(Message m) {
    try {
      // content ou text
      // ignore: invalid_use_of_protected_member
      return (m as dynamic).content as String? ??
          (m as dynamic).text as String? ??
          m.toString();
    } catch (_) {
      return m.toString();
    }
  }

  // Texte secondaire optionnel
  String _messageSecondaryText(Message m) {
    try {
      // author ou description
      return (m as dynamic).author as String? ??
          (m as dynamic).description as String? ??
          '';
    } catch (_) {
      return '';
    }
  }
}
