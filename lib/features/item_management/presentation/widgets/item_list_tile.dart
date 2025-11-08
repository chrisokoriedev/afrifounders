import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../domain/entities/item.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Item list tile widget with checkbox and swipe to delete
class ItemListTile extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const ItemListTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            icon: Icons.delete,
            label: AppStrings.delete,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: item.isCompleted,
          onChanged: (_) => onToggleComplete(),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            color: item.isCompleted
                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
                : null,
          ),
        ),
        subtitle: item.description != null && item.description!.isNotEmpty
            ? Text(
                item.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                  color: item.isCompleted
                      ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              )
            : null,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

