import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../providers/item_notifier.dart';
import '../state/item_state.dart';
import '../pages/sort_dialog.dart';

/// App bar for home page with sort and theme actions
class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showSortDialog(BuildContext context, WidgetRef ref, ItemState state) {
    SortDialog.show(context, ref, state);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemNotifierProvider);

    return AppBar(
      title: const Text(AppStrings.homeTitle),
      actions: [
        // Sort button
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortDialog(context, ref, itemState),
          tooltip: AppStrings.sortBy,
        ),
        // Sort order toggle
        IconButton(
          icon: Icon(
            itemState.sortOrder == SortOrder.ascending
                ? Icons.arrow_upward
                : Icons.arrow_downward,
          ),
          onPressed: () {
            ref.read(itemNotifierProvider.notifier).toggleSortOrder();
          },
          tooltip: itemState.sortOrder == SortOrder.ascending
              ? 'Ascending'
              : 'Descending',
        ),
        // Theme toggle button
        Consumer(
          builder: (context, ref, _) {
            final isDark = ref.watch(themeModeNotifierProvider);
            return IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                ref.read(themeModeNotifierProvider.notifier).toggleTheme();
              },
              tooltip: isDark ? 'Light Mode' : 'Dark Mode',
            );
          },
        ),
      ],
    );
  }
}

