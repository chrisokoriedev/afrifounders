import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/item_notifier.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/items_list_view.dart';
import '../widgets/navigation_helper.dart';

/// Home page displaying list of items
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemNotifierProvider);

    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(itemNotifierProvider.notifier).loadItems();
        },
        child: Column(
          children: [
            const SearchBarWidget(),
            Expanded(
              child: ItemsListView(
                state: itemState,
                onNavigateToAddEdit: NavigationHelper.navigateToAddEditPage,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NavigationHelper.navigateToAddEditPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
