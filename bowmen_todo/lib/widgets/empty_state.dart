import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String filter;

  const EmptyState({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    String message;
    IconData icon;

    switch (filter) {
      case 'active':
        message = 'All caught up!\nNo pending tasks';
        icon = Icons.check_circle_outline;
        break;
      case 'completed':
        message = 'No completed tasks yet\nStart checking off your todos!';
        icon = Icons.task_alt;
        break;
      default:
        message = 'Ready to be productive?\nAdd your first task above';
        icon = Icons.add_task;
    }

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(icon, size: 40, color: const Color(0xFF6366F1)),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
