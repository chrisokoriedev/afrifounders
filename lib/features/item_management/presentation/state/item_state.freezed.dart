// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ItemState {
  List<Item> get items => throw _privateConstructorUsedError;
  List<Item> get filteredItems => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  Failure? get error => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  ItemFilter get filter => throw _privateConstructorUsedError;
  ItemSort get sortBy => throw _privateConstructorUsedError;
  SortOrder get sortOrder => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ItemStateCopyWith<ItemState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemStateCopyWith<$Res> {
  factory $ItemStateCopyWith(ItemState value, $Res Function(ItemState) then) =
      _$ItemStateCopyWithImpl<$Res, ItemState>;
  @useResult
  $Res call(
      {List<Item> items,
      List<Item> filteredItems,
      bool isLoading,
      Failure? error,
      String searchQuery,
      ItemFilter filter,
      ItemSort sortBy,
      SortOrder sortOrder});
}

/// @nodoc
class _$ItemStateCopyWithImpl<$Res, $Val extends ItemState>
    implements $ItemStateCopyWith<$Res> {
  _$ItemStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? filteredItems = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchQuery = null,
    Object? filter = null,
    Object? sortBy = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>,
      filteredItems: null == filteredItems
          ? _value.filteredItems
          : filteredItems // ignore: cast_nullable_to_non_nullable
              as List<Item>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Failure?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as ItemFilter,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as ItemSort,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as SortOrder,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemStateImplCopyWith<$Res>
    implements $ItemStateCopyWith<$Res> {
  factory _$$ItemStateImplCopyWith(
          _$ItemStateImpl value, $Res Function(_$ItemStateImpl) then) =
      __$$ItemStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Item> items,
      List<Item> filteredItems,
      bool isLoading,
      Failure? error,
      String searchQuery,
      ItemFilter filter,
      ItemSort sortBy,
      SortOrder sortOrder});
}

/// @nodoc
class __$$ItemStateImplCopyWithImpl<$Res>
    extends _$ItemStateCopyWithImpl<$Res, _$ItemStateImpl>
    implements _$$ItemStateImplCopyWith<$Res> {
  __$$ItemStateImplCopyWithImpl(
      _$ItemStateImpl _value, $Res Function(_$ItemStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? filteredItems = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? searchQuery = null,
    Object? filter = null,
    Object? sortBy = null,
    Object? sortOrder = null,
  }) {
    return _then(_$ItemStateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Item>,
      filteredItems: null == filteredItems
          ? _value._filteredItems
          : filteredItems // ignore: cast_nullable_to_non_nullable
              as List<Item>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Failure?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as ItemFilter,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as ItemSort,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as SortOrder,
    ));
  }
}

/// @nodoc

class _$ItemStateImpl implements _ItemState {
  const _$ItemStateImpl(
      {final List<Item> items = const [],
      final List<Item> filteredItems = const [],
      this.isLoading = false,
      this.error,
      this.searchQuery = '',
      this.filter = ItemFilter.all,
      this.sortBy = ItemSort.dateUpdated,
      this.sortOrder = SortOrder.descending})
      : _items = items,
        _filteredItems = filteredItems;

  final List<Item> _items;
  @override
  @JsonKey()
  List<Item> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<Item> _filteredItems;
  @override
  @JsonKey()
  List<Item> get filteredItems {
    if (_filteredItems is EqualUnmodifiableListView) return _filteredItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredItems);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final Failure? error;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final ItemFilter filter;
  @override
  @JsonKey()
  final ItemSort sortBy;
  @override
  @JsonKey()
  final SortOrder sortOrder;

  @override
  String toString() {
    return 'ItemState(items: $items, filteredItems: $filteredItems, isLoading: $isLoading, error: $error, searchQuery: $searchQuery, filter: $filter, sortBy: $sortBy, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._filteredItems, _filteredItems) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_filteredItems),
      isLoading,
      error,
      searchQuery,
      filter,
      sortBy,
      sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemStateImplCopyWith<_$ItemStateImpl> get copyWith =>
      __$$ItemStateImplCopyWithImpl<_$ItemStateImpl>(this, _$identity);
}

abstract class _ItemState implements ItemState {
  const factory _ItemState(
      {final List<Item> items,
      final List<Item> filteredItems,
      final bool isLoading,
      final Failure? error,
      final String searchQuery,
      final ItemFilter filter,
      final ItemSort sortBy,
      final SortOrder sortOrder}) = _$ItemStateImpl;

  @override
  List<Item> get items;
  @override
  List<Item> get filteredItems;
  @override
  bool get isLoading;
  @override
  Failure? get error;
  @override
  String get searchQuery;
  @override
  ItemFilter get filter;
  @override
  ItemSort get sortBy;
  @override
  SortOrder get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$ItemStateImplCopyWith<_$ItemStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
