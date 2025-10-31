import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../domain/usecases/add_message.dart';
import '../viewmodels/send_message_view_model.dart';

class SendMessagePage extends StatefulWidget {
  final AddMessage addMessage;
  const SendMessagePage({super.key, required this.addMessage});

  @override
  State<SendMessagePage> createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  late final vm = SendMessageViewModel(widget.addMessage);
  final authorController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVm);
  }

  @override
  void dispose() {
    vm.removeListener(_onVm);
    authorController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _onVm() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final form = _Form(
      authorController: authorController,
      contentController: contentController,
      sending: vm.sending,
      onSend: () async {
        final messenger = ScaffoldMessenger.of(context);
        await vm.send(authorController.text, contentController.text);
        if (vm.success) {
          authorController.clear();
          contentController.clear();
          messenger.showSnackBar(SnackBar(content: Text(t.messageSent)));
        }
      },
      error: vm.error,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLandscape
          ? Row(children: [Expanded(child: form), const SizedBox(width: 24), Expanded(child: _Tips())])
          : ListView(children: [form, const SizedBox(height: 24), _Tips()]),
    );
  }
}

class _Form extends StatelessWidget {
  final TextEditingController authorController;
  final TextEditingController contentController;
  final VoidCallback onSend;
  final bool sending;
  final String? error;

  const _Form({
    required this.authorController,
    required this.contentController,
    required this.onSend,
    required this.sending,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: authorController,
          decoration: InputDecoration(labelText: t.author, prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: contentController,
          decoration: InputDecoration(labelText: t.message, prefixIcon: const Icon(Icons.message)),
          maxLines: 4,
        ),
        const SizedBox(height: 12),
        if (error != null)
          Text(
            error == SendMessageViewModel.errorRequiredKey ? t.errorRequiredFields : error!,
            style: const TextStyle(color: Colors.red),
          ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: sending ? null : onSend,
          icon: sending ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send),
          label: Text(sending ? t.sending : t.send),
        ),
      ],
    );
  }
}

class _Tips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(t.sendTip),
      ),
    );
  }
}
