import 'dart:math';

import '../../domain/entities/message.dart';
import '../../domain/repositories/forum_repository.dart';
import '../local/file_storage.dart';

class ForumRepositoryImpl implements ForumRepository {
  final FileStorage storage;
  ForumRepositoryImpl({FileStorage? storage}) : storage = storage ?? FileStorage('messages.json');

  @override
  Future<List<Message>> getMessages() async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate latency
    final list = await storage.readJsonList();
    return list.map((e) => Message.fromJson(Map<String, dynamic>.from(e))).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> addMessage(Message message) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Simulate intermittent error (20% chance)
    if (Random().nextDouble() < 0.2) {
      throw Exception('Erreur réseau simulée. Veuillez réessayer.');
    }
    final list = await storage.readJsonList();
    final updated = [message.toJson(), ...list.map((e) => Map<String, dynamic>.from(e))];
    await storage.writeJsonList(List<Map<String, dynamic>>.from(updated));
  }
}
