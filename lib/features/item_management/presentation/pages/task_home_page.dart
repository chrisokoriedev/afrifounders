import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/item_notifier.dart';
import '../widgets/task_header_widget.dart';
import '../widgets/date_selector_widget.dart';
import '../widgets/task_sections_widget.dart';
import '../widgets/navigation_helper.dart';
import '../../domain/entities/item.dart';

/// Task-focused home page with date selector and task sections
class TaskHomePage extends ConsumerStatefulWidget {
  const TaskHomePage({super.key});

  @override
  ConsumerState<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends ConsumerState<TaskHomePage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final itemState = ref.watch(itemNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter tasks for selected date
    final selectedDateTasks = itemState.items.where((item) {
      if (item.scheduledDate == null) return false;
      final itemDate = DateTime(
        item.scheduledDate!.year,
        item.scheduledDate!.month,
        item.scheduledDate!.day,
      );
      final selected = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      return itemDate.isAtSameMomentAs(selected);
    }).toList();

    // Calculate statistics
    final completedCount = selectedDateTasks.where((t) => t.isCompleted).length;
    final completedTimeMinutes = selectedDateTasks
        .where((t) => t.isCompleted)
        .fold<int>(0, (sum, t) => sum + (t.timeEstimateMinutes ?? 0));
    final totalEstimatedMinutes = selectedDateTasks
        .fold<int>(0, (sum, t) => sum + (t.timeEstimateMinutes ?? 0));
    final totalEstimatedHours = totalEstimatedMinutes / 60.0;
    final completedHours = completedTimeMinutes / 60.0;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(itemNotifierProvider.notifier).loadItems();
          },
          child: CustomScrollView(
            slivers: [
              // Header with "today" and status indicators
              SliverToBoxAdapter(
                child: TaskHeaderWidget(
                  completedCount: completedCount,
                  completedHours: completedHours,
                  totalEstimatedHours: totalEstimatedHours,
                ),
              ),

              // Date selector
              SliverToBoxAdapter(
                child: DateSelectorWidget(
                  selectedDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
              ),

              // Task sections (Morning/Afternoon)
              SliverToBoxAdapter(
                child: TaskSectionsWidget(
                  tasks: selectedDateTasks,
                  onTaskToggle: (task) {
                    ref.read(itemNotifierProvider.notifier).toggleTaskCompletion(task);
                  },
                  onTaskTap: (task) {
                    // Navigate to edit page
                    NavigationHelper.navigateToAddEditPage(context, item: task);
                  },
                ),
              ),

              // Empty state
              if (selectedDateTasks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks for ${DateFormat('EEEE, MMM d').format(_selectedDate)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add a task',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add task page with selected date
          // Create a temporary item with scheduled date for navigation
          final tempItem = Item(
            id: '',
            title: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            scheduledDate: _selectedDate,
          );
          NavigationHelper.navigateToAddEditPage(context, item: tempItem);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

