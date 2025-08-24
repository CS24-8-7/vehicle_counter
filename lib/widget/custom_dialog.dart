import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onClose;

  const CustomDialog({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 60),
            const SizedBox(height: 16),
            Text(
              title ?? l10n.defaultTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? l10n.defaultMessage,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onClose ?? () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
