import 'package:flutter/material.dart';

class OptionItemMessagetap extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const OptionItemMessagetap({
    super.key,
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 12,
            ),
            Flexible(
              child: Text(
                name,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: .5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
