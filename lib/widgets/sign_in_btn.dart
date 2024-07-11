import 'package:experiences_project/pallete.dart';
// import 'package:experiences_project/screens/intro_page.dart';
import 'package:flutter/material.dart';

class SigninButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onSignUpSuccess;

  const SigninButton({
    super.key,
    required this.formKey,
    required this.onSignUpSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Pallete.inputFieldBordersBfr,
            borderRadius: BorderRadius.circular(25)),
        child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                debugPrint('Form is valid. Proceeding with sign up.');
                onSignUpSuccess();
              }
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(295, 55),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: const Icon(
              Icons.double_arrow_rounded,
              color: Colors.white,
              size: 34,
            )));
  }
}
