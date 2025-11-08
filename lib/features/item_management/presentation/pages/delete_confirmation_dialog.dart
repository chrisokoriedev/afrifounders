import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/item.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/item_notifier.dart';

/// Delete confirmation dialog widget
class DeleteConfirmationDialog extends ConsumerWidget {
  final Item item;

  const DeleteConfirmationDialog({
    super.key,
    required this.item,
  });

  static void show(BuildContext context, Item item, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(item: item),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text(AppStrings.deleteConfirmation),
      content: const Text(AppStrings.deleteConfirmationMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: () {
            ref.read(itemNotifierProvider.notifier).deleteItem(item.id);
            Navigator.of(context).pop();
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: const Text(AppStrings.confirm),
        ),
      ],
    );
  }
}

