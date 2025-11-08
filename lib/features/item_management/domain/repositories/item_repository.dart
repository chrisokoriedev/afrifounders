import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/item.dart';

/// Repository interface for item operations
abstract class ItemRepository {
  /// Get all items
  Future<Either<Failure, List<Item>>> getAllItems();

  /// Get item by id
  Future<Either<Failure, Item>> getItemById(String id);

  /// Add a new item
  Future<Either<Failure, Item>> addItem(Item item);

  /// Update an existing item
  Future<Either<Failure, Item>> updateItem(Item item);

  /// Delete an item
  Future<Either<Failure, void>> deleteItem(String id);
}

