import 'dart:convert';
import 'package:flutter_application_1/utils/decoder.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/categorymodel.dart';
import '../models/taskModel.dart';

class ApiService {
  static Future<List<Category>> fetchCategories() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        print("JWT Token not found.");
        return [];
      }

      final String categoryApi = "${AppConfig.apiUrl}/api/v1/get-categories";

      final response = await http.get(
        Uri.parse(categoryApi),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        print("Failed to load categories: ${response.statusCode}");
        return [];
      }
    } catch (error) {
      print("Error fetching categories: $error");
      return [];
    }
  }

  /// **New function to add a category**
  static Future<bool> addCategory(String categoryName) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        print("JWT Token not found.");
        return false;
      }

      final String addCategoryApi = "${AppConfig.apiUrl}/api/v1/create-categories";

      final response = await http.post(
        Uri.parse(addCategoryApi),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"category_name": categoryName}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Category added successfully.");
        return true;
      } else {
        print("Failed to add category: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error adding category: $error");
      return false;
    }
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

   static Future<bool> createTask({
    required String title,
    required String description,
    required String dueDate,
    required String time,
    required List<int> categoryIds,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("JWT Token not found.");
        return false;
      }

      // Decode token to get user_id
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      int? userId = decodedToken["id"];

      if (userId == null) {
        print("User ID not found in token.");
        return false;
      }

      final String createTaskApi = "${AppConfig.apiUrl}/api/v1/create-task";

      Map<String, dynamic> taskData = {
        "user_id": userId,
        "title": title,
        "description": description,
        "dueDate": dueDate,
        "time": time,
        "category_ids": categoryIds,
      };

      final response = await http.post(
        Uri.parse(createTaskApi),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(taskData),
      );

      if (response.statusCode == 201) {
        print("Task successfully created.");
        return true;
      } else {
        print("Failed to create task: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error creating task: $error");
      return false;
    }
  }

    static Future<List<TaskModel>> fetchTasks() async {
    try {
      // Get user ID from JWT token
      String? userId = await getUserId();
      print(userId);
      if (userId == null) {
        print("User ID not found, returning empty task list.");
        return [];
      }

      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("No token found, returning empty task list.");
        return [];
      }

      // API Endpoint with user ID
      final String fetchTasksApi =
          "${AppConfig.apiUrl}/api/v1/retrieve-task/$userId";

      // Fetch data
      final response = await http.get(
        Uri.parse(fetchTasksApi),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ensure 'tasks' key exists in the response
        if (data.containsKey('tasks')) {
          return (data['tasks'] as List)
              .map((task) => TaskModel.fromJson(task))
              .toList();
        } else {
          print("No 'tasks' field in API response.");
          return [];
        }
      } else {
        print(
          "Failed to fetch tasks: ${response.statusCode} - ${response.body}",
        );
        return [];
      }
    } catch (error) {
      print("Error fetching tasks: $error");
      return [];
    }
  }

  static Future<bool> updateTaskStatus(int taskId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token"); // Retrieve token

    if (token == null) {
      print("No token found!");
      return false;
    }

    final response = await http.patch(
      Uri.parse("${AppConfig.apiUrl}/api/v1/update-task/$taskId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Include token
      },
      body: jsonEncode({"status": "completed"}),
    );

    if (response.statusCode == 200) {
      print("Task updated successfully!");
      return true;
    } else {
      print("Failed to update task: ${response.body}");
      return false;
    }
  }
}
