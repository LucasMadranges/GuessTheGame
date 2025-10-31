import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../data/repositories/offline_blog_repository.dart';
import '../../data/repositories/offline_forum_repository.dart';
import '../../domain/usecases/add_message.dart';
import '../../domain/usecases/get_blog_posts.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/search_messages.dart';
import '../screens/messages_page.dart';
import '../screens/send_message_page.dart';
import '../screens/blog_page.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<Locale> onLocaleChange;
  const HomePage({super.key, required this.onLocaleChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  late final forumRepo = OfflineForumRepository();
  late final blogRepo = OfflineBlogRepository();

  late final getMessages = GetMessages(forumRepo);
  late final addMessage = AddMessage(forumRepo);
  late final searchMessages = SearchMessages();
  late final getBlogPosts = GetBlogPosts(blogRepo);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final pages = [
      MessagesPage(getMessages: getMessages, searchMessages: searchMessages),
      SendMessagePage(addMessage: addMessage),
      BlogPage(getBlogPosts: getBlogPosts),
    ];

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final currentCode = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.forumApp),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            tooltip: t.language,
            onSelected: (value) {
              if (value == 'en') widget.onLocaleChange(const Locale('en'));
              if (value == 'fr') widget.onLocaleChange(const Locale('fr'));
            },
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: 'en',
                checked: currentCode == 'en',
                child: Text(t.languageEnglish),
              ),
              CheckedPopupMenuItem(
                value: 'fr',
                checked: currentCode == 'fr',
                child: Text(t.languageFrench),
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          if (isLandscape)
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(icon: const Icon(Icons.forum_outlined), selectedIcon: const Icon(Icons.forum), label: Text(t.navMessages)),
                NavigationRailDestination(icon: const Icon(Icons.send_outlined), selectedIcon: const Icon(Icons.send), label: Text(t.navSend)),
                NavigationRailDestination(icon: const Icon(Icons.article_outlined), selectedIcon: const Icon(Icons.article), label: Text(t.navBlog)),
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
              items: [
                BottomNavigationBarItem(icon: const Icon(Icons.forum), label: t.navMessages),
                BottomNavigationBarItem(icon: const Icon(Icons.send), label: t.navSend),
                BottomNavigationBarItem(icon: const Icon(Icons.article), label: t.navBlog),
              ],
            ),
    );
  }
}
