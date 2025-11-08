import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/item.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/empty_list_widget.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../providers/item_notifier.dart';
import '../state/item_state.dart';
import '../widgets/item_list_tile.dart';
import 'add_edit_item_page.dart';

/// Home page displaying list of items
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _showDeleteConfirmation(BuildContext context, Item item, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );
  }

  void _navigateToAddEditPage(BuildContext context, {Item? item}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditItemPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
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
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(itemNotifierProvider.notifier).loadItems();
        },
        child: _buildBody(context, ref, itemState),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ItemState state) {
    if (state.isLoading && state.items.isEmpty) {
      return const LoadingWidget();
    }

    if (state.error != null && state.items.isEmpty) {
      return ErrorDisplayWidget(
        message: state.error!.message,
        onRetry: () => ref.read(itemNotifierProvider.notifier).loadItems(),
      );
    }

    if (state.items.isEmpty) {
      return const EmptyListWidget();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spacingS),
      itemCount: state.items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = state.items[index];
        return ItemListTile(
          item: item,
          onTap: () => _navigateToAddEditPage(context, item: item),
          onToggleComplete: () {
            ref.read(itemNotifierProvider.notifier).toggleItemCompletion(item);
          },
          onDelete: () => _showDeleteConfirmation(context, item, ref),
        );
      },
    );
  }
}

