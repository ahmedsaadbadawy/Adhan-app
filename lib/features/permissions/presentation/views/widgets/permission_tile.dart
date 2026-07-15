import 'package:flutter/material.dart';

class PermissionTile extends StatelessWidget {
  const PermissionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final bool granted;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          granted ? Icons.check_circle : Icons.warning_amber_rounded,
          color: granted ? Colors.green : Colors.orange,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: granted
            ? const Text(
                "Done",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )
            : FilledButton(onPressed: onPressed, child: const Text("Grant")),
      ),
    );
  }
}
