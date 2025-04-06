import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/alarm_service.dart';
import 'package:flutter_application_1/service/api_service.dart';
import '../models/categorymodel.dart';
import 'dart:isolate';
import 'dart:ui';

// Add this at the top of your file for notification and alarm handling
void callbackDispatcher() {
  final SendPort? send = IsolateNameServer.lookupPortByName('alarm_isolate');
  send?.send(null);
}

Future<void> showAddTaskModal(
  BuildContext context,
  List<Category> categories,
  VoidCallback refreshTasks,
) async {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  bool enableAlarm = false; // Track if alarm is enabled

  List<int> selectedCategories = [];

 Future<void> scheduleTaskAlarm(int taskId, String title, DateTime alarmTime) async {
  bool success = await AlarmService.scheduleAlarm(taskId, title, alarmTime);
  if (success) {
    debugPrint("Alarm scheduled successfully for $title at $alarmTime");
  } else {
    debugPrint("Failed to schedule alarm");
  }
}
 
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dueDateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      String formattedTime =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
      timeController.text = formattedTime;
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Ensures UI updates when selecting categories
          return AlertDialog(
            title: Text("Add Task"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  TextField(
                    controller: dueDateController,
                    decoration: InputDecoration(
                      labelText: "Due Date",
                      hintText: "Select a date",
                    ),
                    readOnly: true,
                    onTap: () => selectDate(context),
                  ),
                  TextField(
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: "Time",
                      hintText: "Select a time",
                    ),
                    readOnly: true,
                    onTap: () => selectTime(context),
                  ),

                  // Add alarm toggle switch
                  SwitchListTile(
                    title: Text("Set Reminder"),
                    value: enableAlarm,
                    onChanged: (value) {
                      setState(() {
                        enableAlarm = value;
                      });
                    },
                  ),

                  SizedBox(height: 10),
                  Text(
                    "Select Categories:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 10,
                    children:
                        categories.map((category) {
                          bool isSelected = selectedCategories.contains(
                            category.id,
                          );
                          return ChoiceChip(
                            label: Text(category.category_name),
                            selected: isSelected,
                            selectedColor: Colors.blue,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedCategories.add(category.id);
                                } else {
                                  selectedCategories.remove(category.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validate inputs
                  if (titleController.text.isEmpty ||
                      dueDateController.text.isEmpty ||
                      timeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please fill in all required fields"),
                      ),
                    );
                    return;
                  }

                  bool success = await ApiService.createTask(
                    title: titleController.text,
                    description: descriptionController.text,
                    dueDate: dueDateController.text,
                    time: timeController.text,
                    categoryIds: selectedCategories,
                  );

                  if (success) {
                    // If alarm is enabled, schedule it
                    if (enableAlarm) {
                      try {
                        // Parse date and time to create DateTime for alarm
                        List<String> dateParts = dueDateController.text.split(
                          '-',
                        );
                        List<String> timeParts = timeController.text.split(':');

                        DateTime alarmTime = DateTime(
                          int.parse(dateParts[0]),
                          int.parse(dateParts[1]),
                          int.parse(dateParts[2]),
                          int.parse(timeParts[0]),
                          int.parse(timeParts[1]),
                        );

                        // Get task ID (you'll need to modify your API service to return the created task ID)
                        int taskId =
                            1; // Replace with actual task ID from your API response

                        await scheduleTaskAlarm(
                          taskId,
                          titleController.text,
                          alarmTime,
                        );
                      } catch (e) {
                        print("Error scheduling alarm: $e");
                      }
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Task added successfully!")),
                    );
                    refreshTasks();
                    Navigator.pop(context); // Close modal
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add task")),
                    );
                  }
                },
                child: Text("Save"),
              ),
            ],
          );
        },
      );
    },
  );
}
