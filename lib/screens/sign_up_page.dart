import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/screens/login_page.dart';
import 'package:experiences_project/widgets/sign_in_btn.dart';
import 'package:experiences_project/widgets/sign_up_field.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
              const SizedBox(height: 30),
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 30),
              const SignUpField(hintText: "Name"),
              const SizedBox(height: 10),
              const SignUpField(hintText: "Email"),
              const SizedBox(height: 10),
              const SignUpField(hintText: "Password"),
              const SizedBox(height: 20),
              const SigninButton(),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                      children: [
                        TextSpan(text: "Existing User? "),
                        TextSpan(
                            text: "Login",
                            style:
                                TextStyle(color: Pallete.clickHere, fontSize: 20
                                    // decoration: TextDecoration.underline,
                                    )),
                      ]),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ));
  }
}
