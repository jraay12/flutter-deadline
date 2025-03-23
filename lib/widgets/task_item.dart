import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/api_service.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class TaskItem extends StatelessWidget {
  final int id;
  final String title;
  final String status;
  final String dueDate;
  final String time;
  final VoidCallback onUpdate;

  const TaskItem({
    Key? key,
    required this.id,
    required this.title,
    required this.status,
    required this.dueDate,
    required this.time,
    required this.onUpdate,
  }) : super(key: key);

  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date); 
      return DateFormat('MMMM dd, yyyy').format(parsedDate); // October 10, 2004
    } catch (e) {
      return date; // Return original if parsing fails
    }
  }

  String formatTime(String time) {
    try {
      DateTime parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsedTime); // 10:10 AM
    } catch (e) {
      return time; // Return original if parsing fails
    }
  }

  Future<void> updateTaskStatus() async {
    bool success = await ApiService.updateTaskStatus(id);
    if (success) {
      onUpdate();
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
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.task, color: Colors.black54),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  "Due Date: ${formatDate(dueDate)}",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  "Time: ${formatTime(time)}",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  "Status: ${status.toUpperCase()}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: status == "completed" ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          if (status != "completed")
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
