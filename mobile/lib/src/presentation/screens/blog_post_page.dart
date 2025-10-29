import 'package:flutter/material.dart';

import '../../data/remote/post_dto.dart';

class BlogPostPage extends StatelessWidget {
  final PostDto post;

  const BlogPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final d = post.publishedAt.toLocal();
    final date =
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (post.author.isNotEmpty)
            Text(post.author, style: Theme.of(context).textTheme.titleSmall),
          Text(date, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          SelectableText(post.content),
        ],
      ),
    );
  }
}
