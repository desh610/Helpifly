import 'package:flutter/material.dart';

class ChipContainer extends StatefulWidget {
  final List<String> items;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Function(String) onTap;
  final String? initialSelectedItem;

  ChipContainer({
    required this.items,
    required this.selectedColor,
    required this.unselectedColor,
    required this.selectedTextColor,
    required this.unselectedTextColor,
    required this.onTap,
    this.initialSelectedItem,
  });

  @override
  _ChipContainerState createState() => _ChipContainerState();
}

class _ChipContainerState extends State<ChipContainer> {
  late String selectedChip;

  @override
  void initState() {
    super.initState();
    selectedChip = widget.initialSelectedItem ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: widget.items.map<Widget>((word) {
        bool isSelected = selectedChip == word;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedChip = word;
            });
            widget.onTap(word);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? widget.selectedColor : widget.unselectedColor,
            ),
            child: Text(
              word,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? widget.selectedTextColor : widget.unselectedTextColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}