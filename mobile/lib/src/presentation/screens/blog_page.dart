import 'package:flutter/material.dart';

import '../../data/remote/post_api.dart';
import '../../data/remote/post_dto.dart';
import '../../domain/usecases/get_blog_posts.dart';
import 'blog_post_page.dart';

class BlogPage extends StatefulWidget {
  final GetBlogPosts? getBlogPosts;

  const BlogPage({super.key, this.getBlogPosts});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final PostsApi _api = PostsApi();
  Future<List<PostDto>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _api.listPosts();
  }

  Future<void> _reload() async {
    setState(() {
      _future = _api.listPosts();
    });
    await _future;
  }

  @override
  void dispose() {
    _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostDto>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            _future == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Erreur lors du chargement du blog',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _reload,
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        final posts = snapshot.data ?? const <PostDto>[];
        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Aucun article'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _reload,
                  child: const Text('Rafraîchir'),
                ),
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
  final PostDto post;

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
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => BlogPostPage(post: post)));
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(post.content, maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '$yyyy-$mm-$dd',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
