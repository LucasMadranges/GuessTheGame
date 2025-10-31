import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../domain/entities/message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/search_messages.dart';
import '../viewmodels/messages_view_model.dart';

class MessagesPage extends StatefulWidget {
  final GetMessages getMessages;
  final SearchMessages searchMessages;
  const MessagesPage({super.key, required this.getMessages, required this.searchMessages});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late final vm = MessagesViewModel(widget.getMessages, widget.searchMessages);
  final authorController = TextEditingController();
  final queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVm);
    vm.load();
  }

  @override
  void dispose() {
    vm.removeListener(_onVm);
    authorController.dispose();
    queryController.dispose();
    super.dispose();
  }

  void _onVm() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (vm.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.messagesLoadErrorTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(vm.error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: vm.load, child: Text(t.retry)),
          ],
        ),
      );
    }

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final filters = _Filters(
      authorController: authorController,
      queryController: queryController,
      onQueryChanged: vm.setQuery,
      onAuthorChanged: vm.setAuthor,
    );

    final list = _MessagesList(messages: vm.filtered);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: isLandscape
          ? Row(
              children: [
                SizedBox(width: 320, child: filters),
                const VerticalDivider(),
                Expanded(child: list),
              ],
            )
          : Column(
              children: [
                filters,
                const SizedBox(height: 8),
                Expanded(child: list),
              ],
            ),
    );
  }
}

class _Filters extends StatelessWidget {
  final TextEditingController queryController;
  final TextEditingController authorController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onAuthorChanged;

  const _Filters({
    required this.queryController,
    required this.authorController,
    required this.onQueryChanged,
    required this.onAuthorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: queryController,
          decoration: InputDecoration(labelText: t.search, prefixIcon: const Icon(Icons.search)),
          onChanged: onQueryChanged,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: authorController,
          decoration: InputDecoration(labelText: t.filterByAuthor, prefixIcon: const Icon(Icons.person_search)),
          onChanged: onAuthorChanged,
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () {
            queryController.clear();
            authorController.clear();
            onQueryChanged('');
            onAuthorChanged('');
          },
          icon: const Icon(Icons.filter_alt_off),
          label: Text(t.reset),
        )
      ],
    );
  }
}

class _MessagesList extends StatelessWidget {
  final List<Message> messages;
  const _MessagesList({required this.messages});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (messages.isEmpty) {
      return Center(child: Text(t.noMessage));
    }
    return ListView.separated(
      itemCount: messages.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final m = messages[index];
        final isPending = (context.findAncestorStateOfType<_MessagesPageState>()?.vm.pendingIds.contains(m.id) ?? false);
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Row(
            children: [
              Expanded(child: Text(m.author)),
              if (isPending)
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Icon(Icons.schedule, size: 16, color: Colors.orangeAccent),
                ),
            ],
          ),
          subtitle: Text(m.content),
          trailing: Text(_formatDate(m.createdAt), style: Theme.of(context).textTheme.bodySmall),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}\n${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'
        .replaceAll(' ', '');
  }
}
