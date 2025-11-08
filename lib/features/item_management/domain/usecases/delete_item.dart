import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/item_repository.dart';

/// Use case for deleting an item
class DeleteItem {
  final ItemRepository repository;

  DeleteItem(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteItem(id);
  }
}

