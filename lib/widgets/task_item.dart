import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/api_service.dart';

class TaskItem extends StatelessWidget {
  final int id;
  final String title;
  final String status;
  final VoidCallback onUpdate; // Callback to refresh task list

  const TaskItem({
    Key? key,
    required this.id,
    required this.title,
    required this.status,
    required this.onUpdate,
  }) : super(key: key);

  Future<void> updateTaskStatus() async {
    bool success = await ApiService.updateTaskStatus(id);
    if (success) {
      onUpdate(); // Refresh task list
    } else {
      print("Failed to update task");
    }
  }

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
          if (status != "completed") // Show button only for pending tasks
            ElevatedButton(
              onPressed: updateTaskStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Complete"),
            ),
        ],
      ),
    );
  }
}
