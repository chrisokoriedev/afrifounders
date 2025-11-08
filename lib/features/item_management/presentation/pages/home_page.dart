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
import 'add_edit_item_page.dart';
import 'delete_confirmation_dialog.dart';
import 'item_list_tile.dart';
import 'sort_dialog.dart';

/// Home page displaying list of items
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(BuildContext context, Item item, WidgetRef ref) {
    DeleteConfirmationDialog.show(context, item, ref);
  }

  void _navigateToAddEditPage(BuildContext context, {Item? item}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddEditItemPage(item: item),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _showSortDialog(BuildContext context, WidgetRef ref, ItemState state) {
    SortDialog.show(context, ref, state);
  }

  @override
  Widget build(BuildContext context) {
    final itemState = ref.watch(itemNotifierProvider);

    return Scaffold(
      appBar: AppBar(
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
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(itemNotifierProvider.notifier).loadItems();
        },
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: itemState.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(itemNotifierProvider.notifier)
                                .setSearchQuery('');
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  ref.read(itemNotifierProvider.notifier).setSearchQuery(value);
                },
              ),
            ),
            // Items list
            Expanded(
              child: _buildBody(context, ref, itemState),
            ),
          ],
        ),
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
            onTap: () => _navigateToAddEditPage(context, item: item),
            onDelete: () => _showDeleteConfirmation(context, item, ref),
          ),
        );
      },
    );
  }
}
