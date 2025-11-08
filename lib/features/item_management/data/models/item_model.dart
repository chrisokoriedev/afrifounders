import 'package:hive/hive.dart';
import '../../domain/entities/item.dart';

part 'item_model.g.dart';

/// Hive type adapter ID
const int itemModelTypeId = 0;

/// Item model for data layer with Hive persistence
@HiveType(typeId: itemModelTypeId)
class ItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  final bool isCompleted;

  ItemModel({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.isCompleted = false,
  });

  /// Convert ItemModel to Item entity
  Item toEntity() {
    return Item(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert Item entity to ItemModel
  factory ItemModel.fromEntity(Item item) {
    return ItemModel(
      id: item.id,
      title: item.title,
      description: item.description,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}

/// Extension to convert Item entity to ItemModel
extension ItemX on Item {
  /// Convert Item entity to ItemModel
  ItemModel toModel() {
    return ItemModel.fromEntity(this);
  }
}
