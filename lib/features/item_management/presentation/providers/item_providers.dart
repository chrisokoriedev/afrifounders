import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/models/item_model.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../domain/repositories/item_repository.dart';
import '../../domain/usecases/add_item.dart';
import '../../domain/usecases/delete_item.dart';
import '../../domain/usecases/get_all_items.dart';
import '../../domain/usecases/update_item.dart';

part 'item_providers.g.dart';

/// Hive box name for items
const String itemsBoxName = 'items';

/// Provider for Hive box
@Riverpod(keepAlive: true)
Box<ItemModel> itemsBox(ItemsBoxRef ref) {
  return Hive.box<ItemModel>(itemsBoxName);
}

/// Provider for local data source
@Riverpod(keepAlive: true)
LocalDataSource localDataSource(LocalDataSourceRef ref) {
  final box = ref.watch(itemsBoxProvider);
  return LocalDataSourceImpl(box);
}

/// Provider for item repository
@Riverpod(keepAlive: true)
ItemRepository itemRepository(ItemRepositoryRef ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  return ItemRepositoryImpl(dataSource);
}

/// Provider for get all items use case
@Riverpod(keepAlive: true)
GetAllItems getAllItems(GetAllItemsRef ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return GetAllItems(repository);
}

/// Provider for add item use case
@Riverpod(keepAlive: true)
AddItem addItem(AddItemRef ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return AddItem(repository);
}

/// Provider for update item use case
@Riverpod(keepAlive: true)
UpdateItem updateItem(UpdateItemRef ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return UpdateItem(repository);
}

/// Provider for delete item use case
@Riverpod(keepAlive: true)
DeleteItem deleteItem(DeleteItemRef ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return DeleteItem(repository);
}

