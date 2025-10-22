import 'package:flutter/material.dart';

import '../../domain/entities/blog_post.dart';
import '../../domain/usecases/get_blog_posts.dart';
import '../viewmodels/blog_view_model.dart';

class BlogPage extends StatefulWidget {
  final GetBlogPosts getBlogPosts;
  const BlogPage({super.key, required this.getBlogPosts});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late final vm = BlogViewModel(widget.getBlogPosts);

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVm);
    vm.load();
  }

  @override
  void dispose() {
    vm.removeListener(_onVm);
    super.dispose();
  }

  void _onVm() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (vm.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Erreur lors du chargement du blog', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(vm.error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: vm.load, child: const Text('Réessayer')),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) => _PostItem(post: vm.posts[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: vm.posts.length,
    );
  }
}

class _PostItem extends StatelessWidget {
  final BlogPost post;
  const _PostItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(post.body),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${post.publishedAt.year}-${post.publishedAt.month.toString().padLeft(2, '0')}-${post.publishedAt.day.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          ],
        ),
      ),
    );
  }
}
