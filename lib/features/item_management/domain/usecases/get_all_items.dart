import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/item.dart';
import '../repositories/item_repository.dart';

/// Use case for getting all items
class GetAllItems {
  final ItemRepository repository;

  GetAllItems(this.repository);

  Future<Either<Failure, List<Item>>> call() async {
    return await repository.getAllItems();
  }
}

