import '../local/file_storage.dart';
import '../../domain/entities/message.dart';

class OutboxStore {
  static const String outboxFileName = 'messages_outbox.json';

  final FileStorage _storage;
  OutboxStore({FileStorage? storage}) : _storage = storage ?? FileStorage(outboxFileName);

  Future<List<Message>> readAll() async {
    final raw = await _storage.readJsonList();
    return raw.map((e) => Message.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> writeAll(List<Message> list) async {
    await _storage.writeJsonList(list.map((m) => m.toJson()).toList());
  }

  Future<Set<String>> readIds() async {
    final msgs = await readAll();
    return msgs.map((m) => m.id).toSet();
  }

  Future<void> append(Message m) async {
    final list = await readAll();
    list.add(m);
    await writeAll(list);
  }
}
