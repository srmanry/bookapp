import 'package:flutter/material.dart';
import 'package:libararybd/core/util/custom_color.dart';

class CustomBottom extends StatelessWidget {
  final String name;
  final Color bottomColor;
  final VoidCallback? onTap;

  const CustomBottom({
    super.key,
    required this.name,
    required this.bottomColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isEnabled
                  ? bottomColor.withValues(alpha: 0.24)
                  : mutedTextColor.withValues(alpha: 0.14),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: bottomColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: mutedTextColor.withValues(alpha: 0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
