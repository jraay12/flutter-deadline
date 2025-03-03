import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/config.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final String apiUrl =
            "${AppConfig.apiUrl}/auth/v1/create-user"; // Use from config
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": _emailController.text,
            "password": _passwordController.text,
            "firstname": _firstNameController.text,
            "middlename": _middleNameController.text,
            "lastname": _lastNameController.text,
          }),
        );

        if (response.statusCode == 201) {
          // Clear all fields
          _emailController.clear();
          _passwordController.clear();
          _firstNameController.clear();
          _middleNameController.clear();
          _lastNameController.clear();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account Created Successfully")),
          );

          // Navigate back to login screen
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context); // Go back to previous screen (Login)
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to create account: ${response.body}"),
            ),
          );
        }
      } catch (error) {
        print("Error occurred: $error"); // Log the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred. Please try again later.")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Sign Up", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 600 ? 200 : 16,
                  vertical: 20,
                ),
                child: Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Create an Account",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            _emailController,
                            "Email",
                            Icons.email,
                            TextInputType.emailAddress,
                            true,
                          ),
                          SizedBox(height: 12),
                          _buildTextField(
                            _passwordController,
                            "Password",
                            Icons.lock,
                            TextInputType.visiblePassword,
                            true,
                            obscureText: true,
                          ),
                          SizedBox(height: 12),
                          _buildTextField(
                            _firstNameController,
                            "First Name",
                            Icons.person,
                            TextInputType.text,
                            true,
                          ),
                          SizedBox(height: 12),
                          _buildTextField(
                            _middleNameController,
                            "Middle Name (Optional)",
                            Icons.person_outline,
                            TextInputType.text,
                            false,
                          ),
                          SizedBox(height: 12),
                          _buildTextField(
                            _lastNameController,
                            "Last Name",
                            Icons.person,
                            TextInputType.text,
                            true,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 40,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    TextInputType keyboardType,
    bool isRequired, {
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[900],
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return "Please enter your $label";
        }
        if (label == "Email" &&
            !RegExp(
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            ).hasMatch(value!)) {
          return "Enter a valid email address";
        }
        if (label == "Password" && value!.length < 6) {
          return "Password must be at least 6 characters long";
        }
        return null;
      },
    );
  }
}
