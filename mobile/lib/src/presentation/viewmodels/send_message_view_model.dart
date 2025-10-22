import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/message.dart';
import '../../domain/usecases/add_message.dart';

class SendMessageViewModel extends ChangeNotifier {
  final AddMessage _addMessage;
  SendMessageViewModel(this._addMessage);

  bool sending = false;
  String? error;
  bool success = false;

  Future<void> send(String author, String content) async {
    if (author.trim().isEmpty || content.trim().isEmpty) {
      error = 'Auteur et message requis';
      notifyListeners();
      return;
    }
    sending = true;
    success = false;
    error = null;
    notifyListeners();
    try {
      final id = const Uuid().v4();
      final message = Message(
        id: id,
        author: author.trim(),
        content: content.trim(),
        createdAt: DateTime.now(),
      );
      await _addMessage(message);
      success = true;
    } catch (e) {
      error = e.toString();
    } finally {
      sending = false;
      notifyListeners();
    }
  }
}
