import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          spacing: 6,
          children: [
            Icon(icon, color: color, size: 20),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
