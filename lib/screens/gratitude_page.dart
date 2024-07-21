import 'package:experiences_project/shared/menu_bottom.dart';
import 'package:flutter/material.dart';

class GratitudePage extends StatelessWidget {
  const GratitudePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("What Are You Grateful For Today?"),
        backgroundColor: const Color.fromARGB(255, 191, 135, 219),
      ),
      bottomNavigationBar: const MenuBottom(
          backgroundColor: Color.fromARGB(255, 191, 135, 219), currentIndex: 4),
    );
  }
}
