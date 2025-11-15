import 'package:flutter/material.dart';

class FadedScrollView extends StatelessWidget {
  final Widget child;
  final double fadeWidth;
  final EdgeInsetsGeometry padding;
  final Axis scrollDirection;

  const FadedScrollView({
    super.key,
    required this.child,
    this.fadeWidth = 30,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    required this.scrollDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The scrollable content
        SingleChildScrollView(
          scrollDirection: scrollDirection,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),

        // Left fade
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: fadeWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Right fade
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: fadeWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
