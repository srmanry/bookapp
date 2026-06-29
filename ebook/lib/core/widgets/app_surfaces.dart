import "package:flutter/material.dart";
import "package:libararybd/core/util/custom_color.dart";

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [bodyColor, gradientEndColor],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -30,
            child: _GlowOrb(
              size: 220,
              color: appColor.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            top: 180,
            left: -70,
            child: _GlowOrb(
              size: 180,
              color: accentColor.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: -90,
            right: -40,
            child: _GlowOrb(
              size: 200,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class AppSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final Color? color;
  final double radius;

  const AppSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.gradient,
    this.color,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? surfaceColor) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: gradient == null ? borderColor : Colors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: titleColor.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AppPill extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  const AppPill({
    super.key,
    required this.label,
    this.foregroundColor = appColor,
    this.backgroundColor = cardSoftColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class AppInlineMessage extends StatelessWidget {
  final String message;
  final Color accentColor;
  final IconData icon;

  const AppInlineMessage({
    super.key,
    required this.message,
    this.accentColor = dangerColor,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}
