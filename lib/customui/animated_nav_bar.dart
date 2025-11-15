import 'package:flutter/material.dart';

class AnimatedNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  final List<IconData> icons;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;
  final Curve curve;
  final double markerWidth;
  final double markerTopOffset;

  const AnimatedNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.icons,
    this.backgroundColor = const Color(0xFF0E0E0E),
    this.activeColor = Colors.blueAccent,
    this.inactiveColor = Colors.white54,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutExpo,
    this.markerWidth = 40,
    this.markerTopOffset = 0,
  });

  @override
  State<AnimatedNavBar> createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar> {
  final GlobalKey _barKey = GlobalKey();
  late List<GlobalKey> _itemKeys;
  List<double> _centers = [];
  double? _markerLeft; // left position in pixels relative to nav bar
  bool _measured = false;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.icons.length, (_) => GlobalKey());
    // Measure after first layout
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didUpdateWidget(covariant AnimatedNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If number of icons changed, re-create keys and re-measure
    if (oldWidget.icons.length != widget.icons.length) {
      _itemKeys = List.generate(widget.icons.length, (_) => GlobalKey());
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
      return;
    }

    // Re-measure if index changed or when layout might have changed
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    // Reset
    final barContext = _barKey.currentContext;
    if (barContext == null) return;
    final RenderBox barBox = barContext.findRenderObject() as RenderBox;
    final barPos = barBox.localToGlobal(Offset.zero);

    List<double> centers = [];

    for (var k in _itemKeys) {
      final ctx = k.currentContext;
      if (ctx == null) {
        centers.add(double.nan);
        continue;
      }
      final RenderBox box = ctx.findRenderObject() as RenderBox;
      final pos = box.localToGlobal(Offset.zero);
      final centerX = (pos.dx - barPos.dx) + box.size.width / 2;
      centers.add(centerX);
    }

    // If any measurement failed, skip update
    if (centers.any((c) => c.isNaN)) return;

    setState(() {
      _centers = centers;
      _measured = true;
      _markerLeft = _centers[widget.currentIndex] - widget.markerWidth / 2;
    });
  }

  void _moveToIndex(int index) {
    widget.onItemSelected(index);
    if (_centers.isNotEmpty && index >= 0 && index < _centers.length) {
      setState(() {
        _markerLeft = _centers[index] - widget.markerWidth / 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Make sure we measure again after every frame (helps on rotations)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _measure();
    });

    return Container(
      key: _barKey,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: SizedBox(
        height: 74, // enough room for marker + icons
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // marker (positioned when measured)
            if (_measured && _markerLeft != null)
              AnimatedPositioned(
                duration: widget.duration,
                curve: widget.curve,
                left: _markerLeft!,
                top: widget.markerTopOffset,
                child: Container(
                  width: widget.markerWidth,
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.activeColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(widget.markerWidth / 2), bottomRight: Radius.circular(widget.markerWidth / 2)),
                    boxShadow: [
                      // subtle glow
                      /*BoxShadow(
                        color: widget.activeColor.withOpacity(0.25),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )*/
                    ],
                  ),
                ),
              ),

            // Icons row
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(widget.icons.length, (index) {
                    final isSelected = index == widget.currentIndex;
                    return GestureDetector(
                      onTap: () => _moveToIndex(index),
                      child: Container(
                        key: _itemKeys[index],
                        width: 64,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? widget.activeColor.withOpacity(0.0)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: AnimatedScale(
                          scale: isSelected ? 1.2 : 1.0,
                          duration: widget.duration,
                          curve: widget.curve,
                          child: Icon(
                            widget.icons[index],
                            size: 26,
                            color: isSelected ? widget.activeColor : widget.inactiveColor,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
