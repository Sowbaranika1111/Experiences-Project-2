import 'package:experiences_project/pallete.dart';
import 'package:flutter/material.dart';

class SignUpField extends StatelessWidget {
    //every time we initialise the login field , it needs to appear , so passing it as constructor value
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const SignUpField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
  });
  
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints : const BoxConstraints(
        maxWidth: 400,
      ),
      child: TextFormField(

        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,

        decoration:  InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.inputFieldBordersBfr,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.inputFieldBordersAftr,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hintText, // coming from the constructor
          errorStyle: const TextStyle(color: Colors.red),
          )
        ),
      );
  }
}