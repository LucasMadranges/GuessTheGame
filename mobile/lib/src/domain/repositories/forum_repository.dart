import '../entities/message.dart';

abstract class ForumRepository {
  Future<List<Message>> getMessages();
  Future<void> addMessage(Message message);
}
