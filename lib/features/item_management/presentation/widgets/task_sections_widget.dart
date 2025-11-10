import 'package:flutter/material.dart';
import '../../domain/entities/item.dart';
import 'task_item_widget.dart';

/// Widget displaying tasks grouped by Morning and Afternoon sections
class TaskSectionsWidget extends StatelessWidget {
  final List<Item> tasks;
  final Function(Item) onTaskToggle;
  final Function(Item) onTaskTap;

  const TaskSectionsWidget({
    super.key,
    required this.tasks,
    required this.onTaskToggle,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    // Separate tasks by time of day
    final morningTasks = tasks
        .where((t) => t.timeOfDay == 'morning' || t.timeOfDay == null)
        .toList();
    final afternoonTasks = tasks
        .where((t) => t.timeOfDay == 'afternoon')
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Morning section
          if (morningTasks.isNotEmpty) ...[
            _SectionHeader(
              title: 'Morning',
              icon: Icons.wb_sunny_outlined,
            ),
            const SizedBox(height: 12),
            ...morningTasks.map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskItemWidget(
                    task: task,
                    onToggle: () => onTaskToggle(task),
                    onTap: () => onTaskTap(task),
                  ),
                )),
            const SizedBox(height: 24),
          ],

          // Afternoon section
          if (afternoonTasks.isNotEmpty) ...[
            _SectionHeader(
              title: 'Afternoon',
              icon: Icons.star_outline,
            ),
            const SizedBox(height: 12),
            ...afternoonTasks.map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskItemWidget(
                    task: task,
                    onToggle: () => onTaskToggle(task),
                    onTap: () => onTaskTap(task),
                  ),
                )),
          ],

          // If no tasks in either section but we have tasks, show them
          if (morningTasks.isEmpty && afternoonTasks.isEmpty && tasks.isNotEmpty) ...[
            ...tasks.map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskItemWidget(
                    task: task,
                    onToggle: () => onTaskToggle(task),
                    onTap: () => onTaskTap(task),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

