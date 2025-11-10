import 'package:flutter/material.dart';

/// Header widget showing "today" title and status indicators
class TaskHeaderWidget extends StatelessWidget {
  final int completedCount;
  final double completedHours;
  final double totalEstimatedHours;

  const TaskHeaderWidget({
    super.key,
    required this.completedCount,
    required this.completedHours,
    required this.totalEstimatedHours,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE0E0E0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // "today" title
          Text(
            'today',
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),

          // Status indicators
          Row(
            children: [
              // Completed count
              _StatusPill(
                icon: Icons.check_circle_outline,
                text: '$completedCount',
                backgroundColor: surfaceColor,
              ),
              const SizedBox(width: 12),

              // Time spent
              _StatusPill(
                icon: Icons.access_time,
                text: '${completedHours.toStringAsFixed(1)} of ${totalEstimatedHours.toStringAsFixed(1)} hrs',
                backgroundColor: surfaceColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;

  const _StatusPill({
    required this.icon,
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

