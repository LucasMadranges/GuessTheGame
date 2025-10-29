import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemsApi {
  final String baseUrl;
  final http.Client _client;

  ItemsApi({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Uri _uri(String path) => Uri.parse(baseUrl).resolve(path);

  Map<String, String> get _headers => const {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  };

  Future<List<ItemDto>> listItems() async {
    final res = await _client.get(_uri('/items'), headers: _headers);
    _ensure(res, 200);
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => ItemDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ItemDto> createItem({
    required String name,
    String description = '',
  }) async {
    final res = await _client.post(
      _uri('/items'),
      headers: _headers,
      body: jsonEncode({'name': name, 'description': description}),
    );
    _ensure(res, 201);
    return ItemDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<ItemDto> updateItem(
      int id, {
        String? name,
        String? description,
      }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    final res = await _client.put(
      _uri('/items/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );
    _ensure(res, 200);
    return ItemDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deleteItem(int id) async {
    final res = await _client.delete(_uri('/items/$id'), headers: _headers);
    _ensure(res, 204);
  }

  void _ensure(http.Response res, int expected) {
    if (res.statusCode != expected) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  void close() => _client.close();
}

class ItemDto {
  final int id;
  final String name;
  final String description;
  final DateTime updatedAt;

  ItemDto({
    required this.id,
    required this.name,
    required this.description,
    required this.updatedAt,
  });

  factory ItemDto.fromJson(Map<String, dynamic> json) {
    return ItemDto(
      id: json['id'] as int,
      name: json['name'] as String,
      description: (json['description'] ?? '') as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
