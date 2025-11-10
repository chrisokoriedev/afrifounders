import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date selector widget showing days of the week
class DateSelectorWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelectorWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get the start of the week (Monday)
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    // Generate 7 days starting from Monday
    final days = List.generate(7, (index) {
      return startOfWeek.add(Duration(days: index));
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((date) {
          final isSelected = _isSameDay(date, selectedDate);
          final dayName = DateFormat('EEE').format(date);
          final dayNumber = date.day;

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: 48,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.onSurface
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.surface
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$dayNumber',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.surface
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

