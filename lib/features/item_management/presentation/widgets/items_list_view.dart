import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/empty_list_widget.dart';
import '../providers/item_notifier.dart';
import '../state/item_state.dart';
import '../pages/item_list_tile.dart';
import '../pages/delete_confirmation_dialog.dart';
import '../../domain/entities/item.dart';

/// Items list view widget displaying different states
class ItemsListView extends ConsumerWidget {
  final ItemState state;
  final Function(BuildContext, {Item? item}) onNavigateToAddEdit;

  const ItemsListView({
    super.key,
    required this.state,
    required this.onNavigateToAddEdit,
  });

  void _showDeleteConfirmation(BuildContext context, Item item, WidgetRef ref) {
    DeleteConfirmationDialog.show(context, item, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading && state.items.isEmpty) {
      return const LoadingWidget();
    }

    if (state.error != null && state.items.isEmpty) {
      return ErrorDisplayWidget(
        message: state.error!.message,
        onRetry: () => ref.read(itemNotifierProvider.notifier).loadItems(),
      );
    }

    if (state.filteredItems.isEmpty && state.items.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: AppDimensions.iconXL,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: AppDimensions.spacingM),
              Text(
                'No items found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: AppDimensions.spacingS),
              Text(
                'Try adjusting your search',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.items.isEmpty) {
      return const EmptyListWidget();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spacingS),
      itemCount: state.filteredItems.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = state.filteredItems[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: ItemListTile(
            item: item,
            onTap: () => onNavigateToAddEdit(context, item: item),
            onDelete: () => _showDeleteConfirmation(context, item, ref),
          ),
        );
      },
    );
  }
}

