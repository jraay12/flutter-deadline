import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/custom_card.dart';
import 'package:flutter_application_1/widgets/task_item.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isTaskListSelected = true;

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
              onPressed: () {},
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
                children: [
                  TaskCategoryCard(
                    backgroundColor: Colors.yellow,
                    icon: Icons.work,
                    title: "Works",
                    taskCount: "03",
                  ),
                  TaskCategoryCard(
                    backgroundColor: Colors.green,
                    icon: Icons.favorite,
                    title: "Sport",
                    taskCount: "10",
                  ),
                  TaskCategoryCard(
                    backgroundColor: Colors.blue,
                    icon: Icons.person,
                    title: "Habits",
                    taskCount: "4",
                  ),
                  TaskCategoryCard(
                    backgroundColor: Colors.purple,
                    icon: Icons.book,
                    title: "Study",
                    taskCount: "7",
                  ),
                ],
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
                            onPressed: () {},
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
