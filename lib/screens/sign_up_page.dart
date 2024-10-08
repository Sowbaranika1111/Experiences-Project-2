import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/screens/intro_page.dart';
import 'package:experiences_project/widgets/sign_in_btn.dart';
import 'package:experiences_project/widgets/sign_up_field.dart';
import 'package:experiences_project/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:experiences_project/configs.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

//initialising SharedPreferences in init state
  @override
  void initState() {
    // implement initState
    super.initState();
    initSharedPref();
  }

//func to initialise our shared_preference named  prefs

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    // we can make use of this instance 'prefs' to store the data in SharedPreference
  }

  void _onSignUpSuccess() async {
    try {
      var regBody = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      };

      // Sending to backend
      var response = await http.post(Uri.parse(register),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      // Check if the widget is still mounted before using context
      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonResponse = jsonDecode(response.body);
        debugPrint('Response body: $jsonResponse');
        debugPrint("Sign up successful: ${jsonResponse['status']}");

        // Save user details to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('tokenValue', jsonResponse['token']);
        await prefs.setString('userName', jsonResponse['user']['name']);
        await prefs.setString('userEmail', jsonResponse['user']['email']);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registration Successful! Listen, Share and Evolve!'),
        ));

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const IntroPage()));
      } else {
        // Handle error responses
        debugPrint("Sign up failed: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Sign up failed. Please try again.'),
        ));
      }
    } catch (e) {
      debugPrint("Error during sign up: $e");
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height *
                      0.3, // Adjust height as needed
                  child: Image.asset(
                    'assets/signUpIn_img2.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 30),
                SignUpField(
                  hintText: "Name",
                  controller: nameController,
                  keyboardType: TextInputType.name, //specifies the type of keyboard that should be displayed when the text field is focused.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SignUpField(
                  hintText: "Email",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email!";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return "Please enter a valid email address!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SignUpField(
                  hintText: "Password",
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SigninButton(
                  formKey: _formKey,
                  onSignUpSuccess: _onSignUpSuccess,
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                      children: [
                        TextSpan(text: "Existing User? "),
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Pallete.clickHere,
                            fontSize: 20,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
