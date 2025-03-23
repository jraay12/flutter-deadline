import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/api_service.dart';
import '../models/categorymodel.dart';

void showAddTaskModal(
  BuildContext context,
  List<Category> categories,
  VoidCallback refreshTasks,
) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List<int> selectedCategories = [];

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
              SizedBox(height: 10),
              Text(
                "Select Categories:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 10,
                children:
                    categories.map((category) {
                      return ChoiceChip(
                        label: Text(category.category_name),
                        selected: selectedCategories.contains(category.id),
                        onSelected: (selected) {
                          if (selected) {
                            selectedCategories.add(category.id);
                          } else {
                            selectedCategories.remove(category.id);
                          }
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
              bool success = await ApiService.createTask(
                title: titleController.text,
                description: descriptionController.text,
                dueDate: dueDateController.text, // "YYYY-MM-DD"
                time: timeController.text, // "HH:MM:SS"
                categoryIds: selectedCategories,
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Task added successfully!")),
                );
                refreshTasks();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Failed to add task")));
              }
            },
            child: Text("Save"),
          ),
        ],
      );
    },
  );
}
