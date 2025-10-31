import 'package:flutter/foundation.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/search_messages.dart';
import '../../data/repositories/offline_forum_repository.dart';

class MessagesViewModel extends ChangeNotifier {
  final GetMessages _getMessages;
  final SearchMessages _searchMessages;

  MessagesViewModel(this._getMessages, this._searchMessages);

  List<Message> _all = [];
  List<Message> filtered = [];
  bool loading = false;
  String? error;
  String query = '';
  String authorFilter = '';
  Set<String> pendingIds = {};

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      _all = await _getMessages();
      // Essayer d’obtenir les IDs en attente si le repo offline est utilisé
      await _loadPendingIds();
      _apply();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> _loadPendingIds() async {
    try {
      final repo = _getMessages.repository;
      if (repo is OfflineForumRepository) {
        pendingIds = await repo.getPendingIds();
      } else {
        pendingIds = {};
      }
    } catch (_) {
      pendingIds = {};
    }
  }

  void setQuery(String q) {
    query = q;
    _apply();
  }

  void setAuthor(String a) {
    authorFilter = a;
    _apply();
  }

  void _apply() {
    filtered = _searchMessages(_all, query: query, author: authorFilter);
    notifyListeners();
  }
}
