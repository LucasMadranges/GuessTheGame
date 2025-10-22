import 'package:flutter/material.dart';

import '../../data/repositories/blog_repository_impl.dart';
import '../../data/repositories/forum_repository_impl.dart';
import '../../domain/usecases/add_message.dart';
import '../../domain/usecases/get_blog_posts.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/search_messages.dart';
import '../screens/messages_page.dart';
import '../screens/send_message_page.dart';
import '../screens/blog_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  late final forumRepo = ForumRepositoryImpl();
  late final blogRepo = BlogRepositoryImpl();

  late final getMessages = GetMessages(forumRepo);
  late final addMessage = AddMessage(forumRepo);
  late final searchMessages = SearchMessages();
  late final getBlogPosts = GetBlogPosts(blogRepo);

  @override
  Widget build(BuildContext context) {
    final pages = [
      MessagesPage(getMessages: getMessages, searchMessages: searchMessages),
      SendMessagePage(addMessage: addMessage),
      BlogPage(getBlogPosts: getBlogPosts),
    ];

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum App'),
      ),
      body: Row(
        children: [
          if (isLandscape)
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum), label: Text('Messages')),
                NavigationRailDestination(icon: Icon(Icons.send_outlined), selectedIcon: Icon(Icons.send), label: Text('Envoyer')),
                NavigationRailDestination(icon: Icon(Icons.article_outlined), selectedIcon: Icon(Icons.article), label: Text('Blog')),
              ],
            ),
          Expanded(child: pages[_index]),
        ],
      ),
      bottomNavigationBar: isLandscape
          ? null
          : BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Messages'),
                BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Envoyer'),
                BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Blog'),
              ],
            ),
    );
  }
}
