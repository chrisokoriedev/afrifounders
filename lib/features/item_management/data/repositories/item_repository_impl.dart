import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/item_model.dart';

/// Implementation of ItemRepository
class ItemRepositoryImpl implements ItemRepository {
  final LocalDataSource localDataSource;

  ItemRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Item>>> getAllItems() async {
    try {
      final items = await localDataSource.getAllItems();
      return Right(items.map((model) => model.toEntity()).toList());
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Failed to get items: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Item>> getItemById(String id) async {
    try {
      final item = await localDataSource.getItemById(id);
      if (item == null) {
        return Left(CacheFailure('Item not found'));
      }
      return Right(item.toEntity());
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Failed to get item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Item>> addItem(Item item) async {
    try {
      final itemModel = item.toModel();
      final addedItem = await localDataSource.addItem(itemModel);
      return Right(addedItem.toEntity());
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Failed to add item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Item>> updateItem(Item item) async {
    try {
      final itemModel = item.toModel();
      final updatedItem = await localDataSource.updateItem(itemModel);
      return Right(updatedItem.toEntity());
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Failed to update item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    try {
      await localDataSource.deleteItem(id);
      return const Right(null);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Failed to delete item: ${e.toString()}'));
    }
  }
}

