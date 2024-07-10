import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/screens/intro_page.dart';
import 'package:flutter/material.dart';

class SigninButton extends StatelessWidget {
  const SigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Pallete.inputFieldBordersBfr,
            borderRadius: BorderRadius.circular(25)),
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const IntroPage())
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(295, 55),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: const Icon(
              Icons.fingerprint,
              color: Colors.white,
              size: 24,
            )));
  }
}
