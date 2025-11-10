import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../domain/entities/item.dart';

/// Task item widget with checkbox, swipe-to-delete, and time badge
class TaskItemWidget extends StatelessWidget {
  final Item task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surfaceVariant;

    // Build task description
    final taskDescription = _buildTaskDescription(theme);

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      width: 2,
                    ),
                    color: task.isCompleted
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: theme.colorScheme.onPrimary,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),

              // Task description
              Expanded(
                child: taskDescription,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskDescription(ThemeData theme) {
    final title = task.title;

    // Just show the title
    return Text(
      title,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: task.isCompleted
            ? theme.colorScheme.onSurfaceVariant.withOpacity(0.6)
            : theme.colorScheme.onSurface,
        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
      ),
    );
  }
}

