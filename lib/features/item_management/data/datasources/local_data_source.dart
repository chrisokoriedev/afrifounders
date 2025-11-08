import 'package:hive_flutter/hive_flutter.dart';
import '../models/item_model.dart';
import '../../../../core/error/failures.dart';

/// Local data source interface
abstract class LocalDataSource {
  Future<List<ItemModel>> getAllItems();
  Future<ItemModel?> getItemById(String id);
  Future<ItemModel> addItem(ItemModel item);
  Future<ItemModel> updateItem(ItemModel item);
  Future<void> deleteItem(String id);
}

/// Hive implementation of local data source
class LocalDataSourceImpl implements LocalDataSource {
  final Box<ItemModel> box;

  LocalDataSourceImpl(this.box);

  @override
  Future<List<ItemModel>> getAllItems() async {
    try {
      return box.values.toList();
    } catch (e) {
      throw CacheFailure('Failed to load items: ${e.toString()}');
    }
  }

  @override
  Future<ItemModel?> getItemById(String id) async {
    try {
      return box.get(id);
    } catch (e) {
      throw CacheFailure('Failed to get item: ${e.toString()}');
    }
  }

  @override
  Future<ItemModel> addItem(ItemModel item) async {
    try {
      await box.put(item.id, item);
      return item;
    } catch (e) {
      throw CacheFailure('Failed to add item: ${e.toString()}');
    }
  }

  @override
  Future<ItemModel> updateItem(ItemModel item) async {
    try {
      await box.put(item.id, item);
      return item;
    } catch (e) {
      throw CacheFailure('Failed to update item: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      await box.delete(id);
    } catch (e) {
      throw CacheFailure('Failed to delete item: ${e.toString()}');
    }
  }
}

