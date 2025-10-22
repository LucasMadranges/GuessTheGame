import '../entities/message.dart';
import '../repositories/forum_repository.dart';

class GetMessages {
  final ForumRepository repository;
  GetMessages(this.repository);

  Future<List<Message>> call() => repository.getMessages();
}
