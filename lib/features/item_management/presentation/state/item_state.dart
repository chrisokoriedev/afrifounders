import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/item.dart';
import '../../../../core/error/failures.dart';

part 'item_state.freezed.dart';

/// Sort options for items
enum ItemSort {
  dateCreated,
  dateUpdated,
  title,
}

/// Sort order
enum SortOrder {
  ascending,
  descending,
}

/// State class for items list
@freezed
class ItemState with _$ItemState {
  const factory ItemState({
    @Default([]) List<Item> items,
    @Default([]) List<Item> filteredItems,
    @Default(false) bool isLoading,
    Failure? error,
    @Default('') String searchQuery,
    @Default(ItemSort.dateUpdated) ItemSort sortBy,
    @Default(SortOrder.descending) SortOrder sortOrder,
  }) = _ItemState;
}

