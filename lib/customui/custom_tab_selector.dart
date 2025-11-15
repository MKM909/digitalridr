import 'package:flutter/material.dart';

class CustomTabSelector extends StatefulWidget {
  final List<String> tabs;
  final ValueChanged<int>? onTabSelected;
  final int initialIndex;
  final Color selectedColor;
  final Color unselectedColor;
  final Color textColor;
  final double borderRadius;
  final double padding;
  final bool showFadeEdges;

  const CustomTabSelector({
    super.key,
    required this.tabs,
    this.onTabSelected,
    this.initialIndex = 0,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.grey,
    this.textColor = Colors.white,
    this.borderRadius = 10,
    this.padding = 12,
    this.showFadeEdges = true,
  });

  @override
  State<CustomTabSelector> createState() => _CustomTabSelectorState();
}

class _CustomTabSelectorState extends State<CustomTabSelector> {
  late int _selectedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
  }

  void _onSelect(int index) {
    setState(() => _selectedIndex = index);
    widget.onTabSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    Widget tabsRow = Row(
      children: List.generate(widget.tabs.length, (index) {
        final bool selected = _selectedIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: selected ? widget.selectedColor : widget.unselectedColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: () => _onSelect(index),
            child: Padding(
              padding: EdgeInsets.all(widget.padding),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: selected ? widget.textColor : Colors.grey.shade900,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
                child: Text(widget.tabs[index]),
              ),
            ),
          ),
        );
      }),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: widget.showFadeEdges
          ? ShaderMask(
        shaderCallback: (Rect rect) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
            stops: [0.0, 0.05, 0.95, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          child: tabsRow,
        ),
      )
          : SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        child: tabsRow,
      ),
    );
  }
}
