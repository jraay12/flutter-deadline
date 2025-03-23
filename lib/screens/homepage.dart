import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/categorymodel.dart';
import 'package:flutter_application_1/models/taskModel.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/service/api_service.dart';
import 'package:flutter_application_1/widgets/categories_modal.dart';
import 'package:flutter_application_1/widgets/custom_card.dart';
import 'package:flutter_application_1/widgets/custom_toggle.dart';
import 'package:flutter_application_1/widgets/task_item.dart';
import 'package:flutter_application_1/widgets/add_task_modal.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isTaskListSelected = true;
  List<Category> categories = [];
  List<TaskModel> tasks = []; // Load all tasks

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadTasks();
  }

  Future<void> loadCategories() async {
    List<Category> fetchedCategories = await ApiService.fetchCategories();
    setState(() {
      categories = fetchedCategories;
    });
  }

  Future<void> loadTasks() async {
    List<TaskModel> fetchedTasks = await ApiService.fetchTasks();
    setState(() {
      tasks = fetchedTasks; // Fetch all tasks
    });
  }
  
  void _logout() async {
    await ApiService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Logged out successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          title: Text(
            "Deadline Tracker",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: _logout,
              icon: Icon(Icons.person_off_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            CustomToggle(
              isTaskListSelected: isTaskListSelected,
              onToggle:
                  (selected) => setState(() => isTaskListSelected = selected),
            ),
            SizedBox(height: 20),
            _buildCategoryHeader(),
            SizedBox(height: 20),
            _buildCategoryList(),
            SizedBox(height: 40),
            _buildTaskList(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          _buildAddButtonCategories(),
        ],
      ),
    );
  }

  Widget _buildAddButtonCategories() {
    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextButton(
        onPressed: () {
          showAddCategoryModal(context, loadCategories);
        },
        child: Text("Add", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            categories.map((category) {
              return TaskCategoryCard(
                backgroundColor: _getRandomColor(),
                icon: _getIconForCategory(category.category_name),
                title: category.category_name,
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTaskList() {
    // Filter tasks based on selection
    List<TaskModel> displayedTasks =
        isTaskListSelected
            ? tasks.where((task) => task.status == "pending").toList()
            : tasks.where((task) => task.status == "completed").toList();

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => loadTasks(), // Refreshes task list
                child:
                    displayedTasks.isEmpty
                        ? Center(
                          child: Text(
                            "No tasks available!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: displayedTasks.length,
                          itemBuilder: (context, index) {
                            final task = displayedTasks[index];
                            return TaskItem(
                              id: task.id, // Pass task ID
                              title: task.title,
                              status: task.status,
                              onUpdate: loadTasks, // Refresh list after update
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildTaskHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isTaskListSelected ? 'Task List' : 'Completed Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        ElevatedButton.icon(
          onPressed: () {
            showAddTaskModal(context, categories, loadTasks); // Pass loadTasks
          },
          icon: Icon(Icons.add),
          label: Text("Add Task"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }


  Color _getRandomColor() {
    return [
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.red,
    ][Random().nextInt(5)];
  }

  IconData _getIconForCategory(String categoryName) {
    return {
          "Works": Icons.work,
          "Sport": Icons.sports_soccer,
          "Habits": Icons.person,
          "Study": Icons.book,
        }[categoryName] ??
        Icons.category;
  }
}
