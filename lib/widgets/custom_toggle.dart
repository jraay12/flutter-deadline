import 'package:flutter/material.dart';

class CustomToggle extends StatelessWidget {
  final bool isTaskListSelected;
  final ValueChanged<bool> onToggle;

  const CustomToggle({
    Key? key,
    required this.isTaskListSelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onToggle(!isTaskListSelected); // Toggle the selection
      },
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black, // Background color
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              left: isTaskListSelected ? 0 : 80, // Toggle position
              child: Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white, // Toggle button color
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _toggleText('Task List', isTaskListSelected, true),
                _toggleText('Complete', isTaskListSelected, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleText(String text, bool isSelected, bool isLeft) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isSelected == isLeft ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
