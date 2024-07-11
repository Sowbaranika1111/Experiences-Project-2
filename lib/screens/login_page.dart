import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/widgets/sign_in_btn.dart';
import 'package:experiences_project/widgets/sign_up_field.dart';
import 'package:experiences_project/screens/sign_up_page.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onSignUpSuccess() {
    debugPrint("Sign up Successful!");
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
                      'assets/images/signUpIn_img2.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                      if (value.length < 7) {
                        return 'Password must be at least 6 characters long!';
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
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        children: [
                          TextSpan(text: "Create New Account?  "),
                          TextSpan(
                            text: "Click here",
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
      ),
    );
  }
}
