import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/item.dart';
import '../repositories/item_repository.dart';

/// Use case for updating an existing item
class UpdateItem {
  final ItemRepository repository;

  UpdateItem(this.repository);

  Future<Either<Failure, Item>> call(Item item) async {
    return await repository.updateItem(item);
  }
}

