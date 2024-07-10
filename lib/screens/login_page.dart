import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/widgets/login_field.dart';
import 'package:experiences_project/widgets/sign_in_btn.dart';
import 'package:experiences_project/screens/sign_up_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                "Sign In",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 10),
              const LoginField(hintText: "Email"),
              const SizedBox(height: 10),
              const LoginField(hintText: "Password"),
              const SizedBox(height: 20),
              const SigninButton(),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      children: [
                        TextSpan(text: "Create New Account?  "),
                        TextSpan(
                            text: "Click here",
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
