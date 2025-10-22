class Message {
  final String id;
  final String author;
  final String content;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String,
        author: json['author'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };
}
