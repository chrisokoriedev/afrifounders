import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';

/// Empty list widget shown when no items exist
class EmptyListWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const EmptyListWidget({
    super.key,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppDimensions.spacingL,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: AppDimensions.iconXL,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            Text(
              title ?? AppStrings.emptyListTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle ?? AppStrings.emptyListSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

