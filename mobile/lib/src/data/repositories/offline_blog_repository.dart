import 'dart:async';

import '../../domain/entities/blog_post.dart';
import '../../domain/repositories/blog_repository.dart';
import '../local/file_storage.dart';
import '../remote/post_api.dart';
import '../remote/post_dto.dart';

class OfflineBlogRepository implements BlogRepository {
  static const String _cacheFile = 'blog_posts.json';
  static const Duration _networkTimeout = Duration(seconds: 3);

  final PostsApi _api;
  final FileStorage _cache;

  OfflineBlogRepository({PostsApi? api, FileStorage? cache})
      : _api = api ?? PostsApi(),
        _cache = cache ?? FileStorage(_cacheFile);

  @override
  Future<List<BlogPost>> getPosts() async {
    try {
      final list = await _withTimeout(_api.listPosts());
      final posts = list.map(_toDomain).toList()
        ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      await _writeCache(posts);
      return posts;
    } catch (_) {
      return _readCache();
    }
  }

  Future<List<BlogPost>> _readCache() async {
    final raw = await _cache.readJsonList();
    return raw.map((e) => BlogPost.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> _writeCache(List<BlogPost> list) async {
    await _cache.writeJsonList(list.map((p) => p.toJson()).toList());
  }

  BlogPost _toDomain(PostDto dto) => BlogPost(
        id: dto.id.toString(),
        title: dto.title,
        body: dto.content,
        publishedAt: dto.publishedAt,
      );

  Future<T> _withTimeout<T>(Future<T> f) => f.timeout(_networkTimeout);
}
