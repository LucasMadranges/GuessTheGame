import '../entities/message.dart';
import '../repositories/forum_repository.dart';

class AddMessage {
  final ForumRepository repository;
  AddMessage(this.repository);

  Future<void> call(Message message) => repository.addMessage(message);
}
