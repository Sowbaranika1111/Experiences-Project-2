import 'package:experiences_project/widgets/login_field.dart';
import 'package:experiences_project/widgets/sign_in_btn.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
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
              const Text(
                "Sign In",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 30),
              const LoginField(hintText: "Email"),
              const SizedBox(height: 30),
              const LoginField(hintText: "Password"),
              const SizedBox(height: 30),
              const SigninButton(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
