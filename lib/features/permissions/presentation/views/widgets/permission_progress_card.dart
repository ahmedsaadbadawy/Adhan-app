import 'package:flutter/material.dart';

class PermissionProgressCard extends StatelessWidget {
  const PermissionProgressCard({
    super.key,
    required this.completedCount,
    required this.totalCount,
  });

  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;
    final percentage = (progress * 100).toInt();
    final isComplete = completedCount == totalCount;

    final theme = Theme.of(context);
    final activeColor = isComplete ? Colors.green : theme.colorScheme.primary;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Setup Progress",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$completedCount / $totalCount ($percentage%)",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: activeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: progress),
              builder: (context, animatedValue, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: animatedValue,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.outlineVariant,
                    color: activeColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
