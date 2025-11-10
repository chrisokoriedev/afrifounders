import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

/// Item entity representing a task
@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    required String title,
    String? description,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isCompleted,
    String? timeOfDay, // 'morning' or 'afternoon'
    DateTime? scheduledDate,
  }) = _Item;
}

