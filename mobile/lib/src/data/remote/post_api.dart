import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mobile/src/data/remote/post_dto.dart';

import 'base_url.dart';

class PostsApi {
  final String baseUrl;
  final http.Client _client;

  PostsApi({String? baseUrl, http.Client? client})
    : baseUrl = baseUrl ?? defaultBaseUrl(),
      _client = client ?? http.Client();

  Uri _uri(String path) => Uri.parse(baseUrl).resolve(path);

  Map<String, String> get _headers => const {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  };

  Future<List<PostDto>> listPosts() async {
    final res = await _client.get(_uri('/posts'), headers: _headers);
    _ensure(res, 200);
    final data = (jsonDecode(res.body) as List)
        .map((e) => PostDto.fromJson(e as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future<PostDto> getPost(int id) async {
    final res = await _client.get(_uri('/posts/$id'), headers: _headers);
    _ensure(res, 200);
    return PostDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<PostDto> createPost({
    required String title,
    required String content,
    String author = '',
    DateTime? publishedAt,
  }) async {
    final res = await _client.post(
      _uri('/posts'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'content': content,
        'author': author,
        if (publishedAt != null) 'published_at': publishedAt.toIso8601String(),
      }),
    );
    _ensure(res, 201);
    return PostDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<PostDto> updatePost(
    int id, {
    String? title,
    String? content,
    String? author,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (content != null) body['content'] = content;
    if (author != null) body['author'] = author;

    final res = await _client.put(
      _uri('/posts/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );
    _ensure(res, 200);
    return PostDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deletePost(int id) async {
    final res = await _client.delete(_uri('/posts/$id'), headers: _headers);
    _ensure(res, 204);
  }

  void _ensure(Response res, int expected) {
    if (res.statusCode != expected) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  void close() => _client.close();
}
