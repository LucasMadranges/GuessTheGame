import 'package:flutter/foundation.dart';

import '../../domain/entities/blog_post.dart';
import '../../domain/usecases/get_blog_posts.dart';

class BlogViewModel extends ChangeNotifier {
  final GetBlogPosts _getBlogPosts;
  BlogViewModel(this._getBlogPosts);

  bool loading = false;
  String? error;
  List<BlogPost> posts = [];

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      posts = await _getBlogPosts();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
