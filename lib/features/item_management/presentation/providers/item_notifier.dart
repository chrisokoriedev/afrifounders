import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/item.dart';
import '../state/item_state.dart';
import 'item_providers.dart';

part 'item_notifier.g.dart';

/// Item notifier managing CRUD operations
@Riverpod(keepAlive: true)
class ItemNotifier extends _$ItemNotifier {
  @override
  ItemState build() {
    // Load items on initialization after state is set
    Future.microtask(() => loadItems());
    return const ItemState();
  }

  /// Load all items
  Future<void> loadItems() async {
    state = state.copyWith(isLoading: true, error: null);
    final getAllItems = ref.read(getAllItemsProvider);
    final result = await getAllItems();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure,
      ),
      (items) {
        state = state.copyWith(
          items: items,
          isLoading: false,
          error: null,
        );
        _applyFilters();
      },
    );
  }

  /// Apply search and sort to items
  void _applyFilters() {
    List<Item> filtered = List.from(state.items);

    // Apply search
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((item) {
        return item.title.toLowerCase().contains(query) ||
            (item.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply sort
    filtered.sort((a, b) {
      int comparison = 0;
      switch (state.sortBy) {
        case ItemSort.dateCreated:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case ItemSort.dateUpdated:
          comparison = a.updatedAt.compareTo(b.updatedAt);
          break;
        case ItemSort.title:
          comparison = a.title.compareTo(b.title);
          break;
      }
      return state.sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    state = state.copyWith(filteredItems: filtered);
  }

  /// Set search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Set sort option
  void setSort(ItemSort sortBy) {
    state = state.copyWith(sortBy: sortBy);
    _applyFilters();
  }

  /// Toggle sort order
  void toggleSortOrder() {
    state = state.copyWith(
      sortOrder: state.sortOrder == SortOrder.ascending
          ? SortOrder.descending
          : SortOrder.ascending,
    );
    _applyFilters();
  }

  /// Add a new item
  Future<void> addItem(String title, {String? description}) async {
    final now = DateTime.now();
    final item = Item(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: now,
      updatedAt: now,
    );

    final addItemUseCase = ref.read(addItemProvider);
    final result = await addItemUseCase(item);
    result.fold(
      (failure) => state = state.copyWith(error: failure),
      (addedItem) {
        state = state.copyWith(
          items: [...state.items, addedItem],
          error: null,
        );
        _applyFilters();
      },
    );
  }

  /// Update an existing item
  Future<void> updateItem(Item item) async {
    final updatedItem = item.copyWith(updatedAt: DateTime.now());
    final updateItemUseCase = ref.read(updateItemProvider);
    final result = await updateItemUseCase(updatedItem);
    result.fold(
      (failure) => state = state.copyWith(error: failure),
      (updated) {
        state = state.copyWith(
          items: state.items.map((i) => i.id == updated.id ? updated : i).toList(),
          error: null,
        );
        _applyFilters();
      },
    );
  }

  /// Delete an item
  Future<void> deleteItem(String id) async {
    final deleteItemUseCase = ref.read(deleteItemProvider);
    final result = await deleteItemUseCase(id);
    result.fold(
      (failure) => state = state.copyWith(error: failure),
      (_) {
        state = state.copyWith(
          items: state.items.where((i) => i.id != id).toList(),
          error: null,
        );
        _applyFilters();
      },
    );
  }

}

