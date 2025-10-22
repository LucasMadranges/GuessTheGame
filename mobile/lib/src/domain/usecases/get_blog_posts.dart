import '../entities/blog_post.dart';
import '../repositories/blog_repository.dart';

class GetBlogPosts {
  final BlogRepository repository;
  GetBlogPosts(this.repository);

  Future<List<BlogPost>> call() => repository.getPosts();
}
