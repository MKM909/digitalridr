import 'dart:ui';
import 'package:digitalridr/core/app_colors.dart';
import 'package:digitalridr/core/app_gradients.dart';
import 'package:flutter/material.dart';

class FrostedBottomNav extends StatefulWidget {
  final List<IconData> icons;
  final ValueChanged<int> onItemSelected;
  final int selectedIndex;

  const FrostedBottomNav({
    super.key,
    required this.icons,
    required this.onItemSelected,
    this.selectedIndex = 0,
  });

  @override
  State<FrostedBottomNav> createState() => _FrostedBottomNavState();
}

class _FrostedBottomNavState extends State<FrostedBottomNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curve;
  late Animation<double> _animation;
  final int _prevIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack);
    _animation = Tween<double>(begin: 0, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant FrostedBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppGradients.setContext(context);
    AppColors.setContext(context);
    final screenWidth = MediaQuery.of(context).size.width;
    const double totalHorizontalPadding = 64.0;
    final itemWidth = (screenWidth - totalHorizontalPadding) / widget.icons.length;
    const circleSize = 60.0;
    const barHeight = 75.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20,top: 10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                height: barHeight,
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  gradient: AppGradients.frostedBottomNavGradient,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.icons.asMap().entries.map((entry) {
                    int idx = entry.key;
                    return GestureDetector(
                      onTap: () => widget.onItemSelected(idx),
                      child: AnimatedScale(
                        scale: widget.selectedIndex == idx ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        child: AnimatedOpacity(
                          opacity: widget.selectedIndex == idx ? 0.0 : 0.6,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            entry.value,
                            color: AppColors.instance.unselectedIconColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Circle Indicator
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              double animatedLeft = 32 +(widget.selectedIndex * itemWidth) + (itemWidth - circleSize) / 2;
                  // (widget.selectedIndex * itemWidth) +
                  // (itemWidth - circleSize) / 2;
              return Positioned(
                left: animatedLeft,
                bottom: (barHeight - circleSize) / 2,
                child: Transform.scale(
                  scale: 1 + 0.1 * (1 - _curve.value),
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Icon(
                      widget.icons[widget.selectedIndex],
                      color: AppColors.instance.iconColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}