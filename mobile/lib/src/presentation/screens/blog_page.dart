import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../data/remote/post_api.dart';
import '../../data/remote/post_dto.dart';
import '../../domain/usecases/get_blog_posts.dart';
import '../../domain/entities/blog_post.dart';
import 'blog_post_page.dart';

class BlogPage extends StatefulWidget {
  final GetBlogPosts? getBlogPosts;

  const BlogPage({super.key, this.getBlogPosts});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  Future<List<BlogPost>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<BlogPost>> _load() async {
    if (widget.getBlogPosts != null) {
      return widget.getBlogPosts!();
    }
    // Fallback direct API (dev only)
    final api = PostsApi();
    final list = await api.listPosts();
    api.close();
    return list
        .map((e) => BlogPost(
              id: e.id.toString(),
              title: e.title,
              body: e.content,
              publishedAt: e.publishedAt,
            ))
        .toList();
  }

  Future<void> _reload() async {
    setState(() {
      _future = _load();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return FutureBuilder<List<BlogPost>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || _future == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.blogLoadErrorTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('${snapshot.error}', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _reload, child: Text(t.retry)),
              ],
            ),
          );
        }

        final posts = snapshot.data ?? const <BlogPost>[];
        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t.noArticle),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _reload, child: Text(t.refresh)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => BlogPageItem(post: posts[index]),
          ),
        );
      },
    );
  }
}

class BlogPageItem extends StatelessWidget {
  final BlogPost post;

  const BlogPageItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final d = post.publishedAt.toLocal();
    final yyyy = d.year.toString().padLeft(4, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => BlogPostPage(post: _toDto(post))),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(post.body, maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Text('$yyyy-$mm-$dd', style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // petit adaptateur pour réutiliser BlogPostPage qui attend un PostDto
  PostDto _toDto(BlogPost p) => PostDto(
        id: int.tryParse(p.id) ?? 0,
        title: p.title,
        content: p.body,
        author: '',
        publishedAt: p.publishedAt,
        updatedAt: p.publishedAt,
      );
}
