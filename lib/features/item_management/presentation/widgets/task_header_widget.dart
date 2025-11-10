import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/theme_provider.dart';

/// Header widget showing "today" title and status indicators
class TaskHeaderWidget extends ConsumerWidget {
  final int completedCount;

  const TaskHeaderWidget({
    super.key,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surfaceVariant;
    final isDarkMode = ref.watch(themeModeNotifierProvider);

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

          // Status indicator and theme switcher
          Row(
            children: [
              // Status indicator
              _StatusPill(
                icon: Icons.check_circle_outline,
                text: '$completedCount',
                backgroundColor: surfaceColor,
              ),
              const SizedBox(width: 12),

              // Theme switcher
              IconButton(
                onPressed: () {
                  ref.read(themeModeNotifierProvider.notifier).toggleTheme();
                },
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                tooltip: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
                style: IconButton.styleFrom(
                  backgroundColor: surfaceColor,
                  foregroundColor: theme.colorScheme.onSurface,
                ),
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

