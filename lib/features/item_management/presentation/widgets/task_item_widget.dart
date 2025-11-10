import 'package:flutter/material.dart';
import '../../domain/entities/item.dart';

/// Task item widget with checkbox, @client format, and time badge
class TaskItemWidget extends StatelessWidget {
  final Item task;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE8E8E8);

    // Build task description
    final taskDescription = _buildTaskDescription(theme);

    return GestureDetector(
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

