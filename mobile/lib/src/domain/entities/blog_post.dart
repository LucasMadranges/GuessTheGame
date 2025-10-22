class BlogPost {
  final String id;
  final String title;
  final String body;
  final DateTime publishedAt;

  BlogPost({
    required this.id,
    required this.title,
    required this.body,
    required this.publishedAt,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) => BlogPost(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        publishedAt: DateTime.parse(json['publishedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'publishedAt': publishedAt.toIso8601String(),
      };
}
