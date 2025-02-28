import 'package:flutter/material.dart';

class TaskCategoryCard extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String taskCount;

  const TaskCategoryCard({
    Key? key,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.taskCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 160,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(50), // Curved bottom-right
        ),
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(10), // Adds space between cards
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: backgroundColor.withOpacity(0.6),
            child: Icon(icon, color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "+$taskCount task",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
