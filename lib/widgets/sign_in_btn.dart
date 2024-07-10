import 'package:experiences_project/pallete.dart';
import 'package:flutter/material.dart';

class SigninButton extends StatelessWidget {
  const SigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color : Pallete.inputFieldBordersBfr,
        borderRadius: BorderRadius.circular(25)
      ),
      child: ElevatedButton(onPressed: (){},
       
       style : ElevatedButton.styleFrom(
        fixedSize: const Size(395,55),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,

       ),
       child: const Text(
        'Sign in',
        style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize:17, 
       ),
       ),
       ),
    );
  }
}