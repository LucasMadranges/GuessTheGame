

class PostDto {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime publishedAt;
  final DateTime updatedAt;

  PostDto({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.publishedAt,
    required this.updatedAt,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) => PostDto(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    author: (json['author'] ?? '') as String,
    publishedAt: DateTime.parse(json['published_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}
