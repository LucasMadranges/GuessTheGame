import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class LoadingErrorView extends StatelessWidget {
  final bool loading;
  final Object? error;
  final VoidCallback? onRetry;
  final Widget child;

  const LoadingErrorView({
    super.key,
    required this.loading,
    required this.error,
    required this.child,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (loading) {
      return Center(child: Text(l10n.loading));
    }
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.error),
            const SizedBox(height: 8),
            if (onRetry != null)
              ElevatedButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      );
    }
    return child;
  }
}
