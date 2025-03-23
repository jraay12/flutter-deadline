import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/api_service.dart';

void showAddCategoryModal(BuildContext context, VoidCallback onCategoryAdded) {
  TextEditingController categoryController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add Category"),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(labelText: "Category Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              String categoryName = categoryController.text.trim();
              if (categoryName.isNotEmpty) {
                bool success = await ApiService.addCategory(categoryName);
                if (success) {
                  Navigator.pop(context);
                  onCategoryAdded(); // Refresh categories after adding
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Category added successfully!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to add category.")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Category name cannot be empty")),
                );
              }
            },
            child: Text("Save"),
          ),
        ],
      );
    },
  );
}
