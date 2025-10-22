import '../../domain/entities/blog_post.dart';
import '../../domain/repositories/blog_repository.dart';
import '../local/file_storage.dart';

class BlogRepositoryImpl implements BlogRepository {
  final FileStorage storage;
  BlogRepositoryImpl({FileStorage? storage}) : storage = storage ?? FileStorage('blog.json');

  @override
  Future<List<BlogPost>> getPosts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final list = await storage.readJsonList();
    final posts = list.map((e) => BlogPost.fromJson(Map<String, dynamic>.from(e))).toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return posts;
  }
}
