import 'package:flutter/material.dart';


class TaskItem extends StatelessWidget {
  final String title;

  const TaskItem({Key? key, required this.title})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light background for each item
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.group, color: Colors.black54), // Example icon
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),

        ],
      ),
    );
  }
}
