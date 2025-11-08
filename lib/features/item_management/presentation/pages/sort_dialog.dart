import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/item_notifier.dart';
import '../state/item_state.dart';

/// Sort dialog widget
class SortDialog extends ConsumerWidget {
  final ItemState state;

  const SortDialog({
    super.key,
    required this.state,
  });

  static void show(BuildContext context, WidgetRef ref, ItemState state) {
    showDialog(
      context: context,
      builder: (context) => SortDialog(state: state),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text(AppStrings.sortBy),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(AppStrings.sortDateCreated),
            leading: Radio<ItemSort>(
              value: ItemSort.dateCreated,
              groupValue: state.sortBy,
              onChanged: (value) {
                if (value != null) {
                  ref.read(itemNotifierProvider.notifier).setSort(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            onTap: () {
              ref.read(itemNotifierProvider.notifier).setSort(ItemSort.dateCreated);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text(AppStrings.sortDateUpdated),
            leading: Radio<ItemSort>(
              value: ItemSort.dateUpdated,
              groupValue: state.sortBy,
              onChanged: (value) {
                if (value != null) {
                  ref.read(itemNotifierProvider.notifier).setSort(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            onTap: () {
              ref.read(itemNotifierProvider.notifier).setSort(ItemSort.dateUpdated);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text(AppStrings.sortTitle),
            leading: Radio<ItemSort>(
              value: ItemSort.title,
              groupValue: state.sortBy,
              onChanged: (value) {
                if (value != null) {
                  ref.read(itemNotifierProvider.notifier).setSort(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            onTap: () {
              ref.read(itemNotifierProvider.notifier).setSort(ItemSort.title);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text(AppStrings.sortCompletion),
            leading: Radio<ItemSort>(
              value: ItemSort.completionStatus,
              groupValue: state.sortBy,
              onChanged: (value) {
                if (value != null) {
                  ref.read(itemNotifierProvider.notifier).setSort(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            onTap: () {
              ref.read(itemNotifierProvider.notifier).setSort(ItemSort.completionStatus);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
      ],
    );
  }
}

