import 'dart:async';

import '../../domain/entities/message.dart';
import '../../domain/repositories/forum_repository.dart';
import '../local/file_storage.dart';
import '../local/outbox_store.dart';
import '../remote/items_api.dart';
import '../remote/base_url.dart';

class OfflineForumRepository implements ForumRepository {
  static const String _cacheFile = 'messages.json';
  static const Duration _networkTimeout = Duration(seconds: 3);

  final ItemsApi _api;
  final FileStorage _cache;
  final OutboxStore _outbox;

  OfflineForumRepository({ItemsApi? api, FileStorage? cache, OutboxStore? outbox})
      : _api = api ?? ItemsApi(baseUrl: defaultBaseUrl()),
        _cache = cache ?? FileStorage(_cacheFile),
        _outbox = outbox ?? OutboxStore();

  // Permettre à l’UI de connaître les IDs en attente
  Future<Set<String>> getPendingIds() => _outbox.readIds();

  @override
  Future<List<Message>> getMessages() async {
    // Tente une synchro rapide des messages en attente.
    await _trySyncPending();

    try {
      final items = await _withTimeout(_api.listItems());
      final remote = items.map(_toMessage).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      // Met à jour le cache avec la dernière vue serveur
      await _writeCache(remote);
      // Ajoute les messages encore en attente pour l'affichage
      final pending = await _outbox.readAll();
      final combined = [...remote, ...pending];
      return combined;
    } catch (_) {
      // Hors-ligne: retourne le cache + outbox
      final cached = await _readCache();
      final pending = await _outbox.readAll();
      return [...cached, ...pending];
    }
  }

  @override
  Future<void> addMessage(Message message) async {
    // Écrit d'abord localement pour une UX réactive
    await _appendToCache(message);

    try {
      await _withTimeout(_api.createItem(
        name: _messagePrimaryText(message),
        description: _messageSecondaryText(message),
      ));
      // Après succès, on peut retenter une récupération serveur pour rafraîchir le cache
      await _refreshCacheFromServer();
    } catch (_) {
      // Hors-ligne: met en outbox pour envoi ultérieur
      await _outbox.append(message);
    }
  }

  // --- Sync helpers ---
  Future<void> _trySyncPending() async {
    final pending = await _outbox.readAll();
    if (pending.isEmpty) return;

    final stillPending = <Message>[];
    for (final m in pending) {
      try {
        await _withTimeout(_api.createItem(
          name: _messagePrimaryText(m),
          description: _messageSecondaryText(m),
        ));
      } catch (_) {
        stillPending.add(m);
      }
    }
    // Écrit la nouvelle outbox
    await _outbox.writeAll(stillPending);

    // Si tout (ou une partie) a réussi, rafraîchir le cache
    if (stillPending.length != pending.length) {
      await _refreshCacheFromServer();
    }
  }

  Future<void> _refreshCacheFromServer() async {
    try {
      final items = await _withTimeout(_api.listItems());
      final remote = items.map(_toMessage).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      await _writeCache(remote);
    } catch (_) {
      // toujours hors-ligne: ignorer
    }
  }

  Future<T> _withTimeout<T>(Future<T> future) => future.timeout(_networkTimeout);

  // --- Local cache helpers ---
  Future<List<Message>> _readCache() async {
    final raw = await _cache.readJsonList();
    return raw.map((e) => Message.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> _writeCache(List<Message> list) async {
    await _cache.writeJsonList(list.map((m) => m.toJson()).toList());
  }

  Future<void> _appendToCache(Message m) async {
    final list = await _readCache();
    list.add(m);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    await _writeCache(list);
  }

  // --- Mapping / utils ---
  Message _toMessage(ItemDto i) {
    return Message(
      id: i.id.toString(),
      content: i.description.isNotEmpty ? i.description : '',
      author: i.name,
      createdAt: i.updatedAt.toUtc(),
    );
  }

  String _messagePrimaryText(Message m) => m.content.isNotEmpty ? m.content : m.author;
  String _messageSecondaryText(Message m) => m.content.isNotEmpty ? m.author : '';
}
