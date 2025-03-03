import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/models/categorymodel.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/widgets/custom_card.dart';
import 'package:flutter_application_1/widgets/task_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isTaskListSelected = true;
  List<Category> categories = []; // Use the model instead of dynamic list

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

Color getRandomColor() {
  List<Color> colors = [Colors.yellow, Colors.green, Colors.blue, Colors.purple, Colors.red];
  return colors[Random().nextInt(colors.length)];
}

IconData getIconForCategory(String categoryName) {
  Map<String, IconData> iconMap = {
    "Works": Icons.work,
    "Sport": Icons.sports_soccer,
    "Habits": Icons.person,
    "Study": Icons.book,
  };

  return iconMap[categoryName] ?? Icons.category; // Default icon
}

  Future<void> fetchCategories() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(
        'token',
      ); // Replace 'jwt_token' with your actual key

      if (token == null) {
        print("JWT Token not found.");
        return;
      }

      final String categoryApi =
          "${AppConfig.apiUrl}/api/v1/get-categories"; // Use from config

      final response = await http.get(
        Uri.parse(categoryApi),
        headers: {
          'Authorization': 'Bearer $token', // Add JWT token to request headers
          'Content-Type': 'application/json',
        },
      );
    print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = data.map((json) => Category.fromJson(json)).toList();
        });
      } else {
        print("Failed to load categories: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching categories: $error");
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the stored token
    await prefs.remove("token");

    // Navigate back to the login screen and clear history
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // This removes all previous routes
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Logged out successfully")));
  }

  void _showAddTaskModal(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController dueDateController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    List<int> selectedCategories = [];

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
                    hintText: "YYYY-MM-DD",
                  ),
                ),
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                    labelText: "Time",
                    hintText: "HH:MM:SS",
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: Text("Work"),
                      selected: selectedCategories.contains(1),
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? selectedCategories.add(1)
                              : selectedCategories.remove(1);
                        });
                      },
                    ),
                    ChoiceChip(
                      label: Text("Sport"),
                      selected: selectedCategories.contains(5),
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? selectedCategories.add(5)
                              : selectedCategories.remove(5);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Process task submission
                Map<String, dynamic> newTask = {
                  "user_id": 1,
                  "title": titleController.text,
                  "description": descriptionController.text,
                  "dueDate": dueDateController.text,
                  "time": timeController.text,
                  "category_ids": selectedCategories,
                };

                print(newTask); // Replace this with API call
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          title: const Text(
            "Deadline Tracker",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                await _logout(); // Call the logout function
              },
              icon: const Icon(Icons.person_off_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            // Toggle Button Below AppBar
            const SizedBox(height: 10), // Space below AppBar
            CustomToggle(
              isTaskListSelected: isTaskListSelected,
              onToggle: (selected) {
                setState(() {
                  isTaskListSelected = selected;
                });
              },
            ),
            const SizedBox(height: 20), // Space before content
            Container(
              width: double.infinity, // Ensures it takes full width
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ), // Adds horizontal padding
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Pushes items to edges
                children: [
                  Text(
                    'Categories',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black, // Background color
                      borderRadius: BorderRadius.circular(
                        100,
                      ), // Rounded corners
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.white), // White text
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Space before content
           SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
                      return TaskCategoryCard(
                        backgroundColor:
                            getRandomColor(), // Function to assign a color
                        icon: getIconForCategory(
                          category.category_name,
                        ), // Function to assign an icon
                        title: category.category_name,
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Light shadow
                      blurRadius: 10,
                      offset: Offset(0, 4), // Slight bottom shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isTaskListSelected ? 'Task List' : 'Completed Tasks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _showAddTaskModal(context);
                            },
                            child: Text(
                              "Add Task",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // FIX: Use Expanded and filter tasks
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount:
                            isTaskListSelected ? 10 : 10, // 1-10 OR 11-20
                        itemBuilder: (context, index) {
                          int taskNumber =
                              isTaskListSelected ? index + 1 : index + 11;
                          return TaskItem(title: "Task $taskNumber");
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Main Content
          ],
        ),
      ),
    );
  }
}

Color getRandomColor() {
  List<Color> colors = [
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.red,
  ];
  return colors[Random().nextInt(colors.length)];
}

IconData getIconForCategory(String categoryName) {
  Map<String, IconData> iconMap = {
    "Works": Icons.work,
    "Sport": Icons.sports_soccer,
    "Habits": Icons.person,
    "Study": Icons.book,
  };

  return iconMap[categoryName] ?? Icons.category; // Default icon
}


// Toggle Button Component
class CustomToggle extends StatefulWidget {
  final bool isTaskListSelected;
  final ValueChanged<bool> onToggle;

  const CustomToggle({
    Key? key,
    required this.isTaskListSelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  _CustomToggleState createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  late bool isTaskListSelected;

  @override
  void initState() {
    super.initState();
    isTaskListSelected = widget.isTaskListSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isTaskListSelected = !isTaskListSelected;
          });
          widget.onToggle(isTaskListSelected);
        },
        child: Container(
          width: 160,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black, // Background color (only for toggle)
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                left: isTaskListSelected ? 0 : 80,
                child: Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _toggleText('Task List', true),
                  _toggleText('Complete', false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleText(String text, bool isLeft) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isTaskListSelected == isLeft ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
